extends CharacterBody2D


signal vida_cambiada(actual: int, maximo: int)
signal ha_muerto

@export var velocidad: float = 130.0
@export var velocidad_dash: float = 420.0
@export var duracion_dash: float = 0.18
@export var cooldown_dash: float = 0.8
@export var vida_maxima: int = 120
@export var cadencia_disparo: float = 0.25

var vida: int
var direccion_mirada: Vector2 = Vector2.RIGHT
var puede_disparar: bool = true
var en_dash: bool = false
var puede_dashear: bool = true
var muerto: bool = false

const BALA = preload("res://scenes/Bala.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var punto_disparo: Marker2D = $PuntoDisparo

func _ready() -> void:
	vida = vida_maxima
	vida_cambiada.emit(vida, vida_maxima)
	_crear_animaciones()
	sprite.play("idle")

func _crear_animaciones() -> void:
	
	var tex: Texture2D = preload("res://assets/sprites/spritesheet_agente.png")
	var frames := SpriteFrames.new()

	frames.add_animation("idle")
	frames.set_animation_speed("idle", 2.0)
	frames.set_animation_loop("idle", true)
	for i in [0, 4]:
		frames.add_frame("idle", _recortar(tex, i))

	frames.add_animation("caminar")
	frames.set_animation_speed("caminar", 8.0)
	frames.set_animation_loop("caminar", true)
	for i in [1, 2]:
		frames.add_frame("caminar", _recortar(tex, i))

	frames.add_animation("atacar")
	frames.set_animation_speed("atacar", 12.0)
	frames.set_animation_loop("atacar", false)
	frames.add_frame("atacar", _recortar(tex, 3))

	frames.add_animation("morir")
	frames.set_animation_speed("morir", 6.0)
	frames.set_animation_loop("morir", false)
	frames.add_frame("morir", _recortar(tex, 0))
	frames.add_frame("morir", _recortar(tex, 4))

	sprite.sprite_frames = frames
	sprite.scale = Vector2(1.7, 1.7) 

func _recortar(tex: Texture2D, indice: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = tex
	atlas.region = Rect2(indice * 32, 0, 32, 32)
	return atlas

func _physics_process(_delta: float) -> void:
	if muerto:
		return

	if not en_dash:
		_procesar_movimiento()
		_procesar_dash()

	move_and_slide()
	_actualizar_animacion()

func _procesar_movimiento() -> void:
	var dir := Vector2.ZERO
	dir.x = Input.get_axis("mover_izquierda", "mover_derecha")
	dir.y = Input.get_axis("mover_arriba", "mover_abajo")
	dir = dir.normalized()

	if dir != Vector2.ZERO:
		direccion_mirada = dir
		
		if dir.x != 0:
			sprite.flip_h = dir.x < 0

	velocity = dir * velocidad

func _procesar_dash() -> void:
	if Input.is_action_just_pressed("dash") and puede_dashear and velocity != Vector2.ZERO:
		_hacer_dash()

func _hacer_dash() -> void:
	en_dash = true
	puede_dashear = false
	velocity = direccion_mirada * velocidad_dash
	sprite.modulate = Color(1, 1, 1, 0.5)  #

	await get_tree().create_timer(duracion_dash).timeout
	en_dash = false
	sprite.modulate = Color.WHITE

	await get_tree().create_timer(cooldown_dash).timeout
	puede_dashear = true

func _input(event: InputEvent) -> void:
	if muerto:
		return
	if event.is_action_pressed("disparar") and puede_disparar:
		_disparar()

func _disparar() -> void:
	puede_disparar = false
	sprite.play("atacar")

	var bala := BALA.instantiate()
	bala.global_position = punto_disparo.global_position
	bala.direccion = direccion_mirada
	bala.es_del_jugador = true
	get_tree().current_scene.add_child(bala)

	AudioManager.sonido_disparo()

	await get_tree().create_timer(cadencia_disparo).timeout
	puede_disparar = true

func _actualizar_animacion() -> void:
	if muerto:
		return
	if sprite.animation == "atacar" and sprite.is_playing():
		return
	if velocity.length() > 5.0:
		if sprite.animation != "caminar":
			sprite.play("caminar")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")

func recibir_dano(cantidad: int) -> void:
	if muerto or en_dash:
		return
	vida -= cantidad
	vida = max(vida, 0)
	vida_cambiada.emit(vida, vida_maxima)
	AudioManager.sonido_dano()

	
	sprite.modulate = Color(1, 0.3, 0.3)
	var t := create_tween()
	t.tween_property(sprite, "modulate", Color.WHITE, 0.25)

	if vida <= 0:
		_morir()

func _morir() -> void:
	muerto = true
	velocity = Vector2.ZERO
	sprite.play("morir")
	AudioManager.sonido_muerte()
	ha_muerto.emit()
