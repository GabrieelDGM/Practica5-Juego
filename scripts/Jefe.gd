extends CharacterBody2D


signal vida_cambiada(actual: int, maximo: int)
signal ha_muerto

@export var vida_maxima: int = 120
@export var velocidad: float = 40.0

var vida: int
var jugador: Node2D = null
var fase: int = 1            
var muerto: bool = false
var atacando: bool = false

const BALA = preload("res://scenes/Bala.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	vida = vida_maxima
	vida_cambiada.emit(vida, vida_maxima)
	add_to_group("jefe")
	_crear_animaciones()
	sprite.play("idle")
	_buscar_jugador()
	_rutina_ataque()

func _buscar_jugador() -> void:
	await get_tree().process_frame
	jugador = get_tree().get_first_node_in_group("jugador")

func _crear_animaciones() -> void:
	var tex: Texture2D = preload("res://assets/sprites/spritesheet_jefe.png")
	var frames := SpriteFrames.new()

	frames.add_animation("idle")
	frames.set_animation_speed("idle", 2.0)
	frames.set_animation_loop("idle", true)
	for i in [0, 1, 2]:
		frames.add_frame("idle", _recortar(tex, i))

	frames.add_animation("atacar")
	frames.set_animation_speed("atacar", 10.0)
	frames.set_animation_loop("atacar", false)
	frames.add_frame("atacar", _recortar(tex, 3))
	frames.add_frame("atacar", _recortar(tex, 4))

	frames.add_animation("morir")
	frames.set_animation_speed("morir", 5.0)
	frames.set_animation_loop("morir", false)
	frames.add_frame("morir", _recortar(tex, 0))

	sprite.sprite_frames = frames
	sprite.scale = Vector2(1.8, 1.8)  

func _recortar(tex: Texture2D, indice: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = tex
	atlas.region = Rect2(indice * 32, 0, 32, 32)
	return atlas

func _physics_process(_delta: float) -> void:
	if muerto or jugador == null or not is_instance_valid(jugador):
		return

	
	var dir := (jugador.global_position - global_position).normalized()
	var v := velocidad if fase == 1 else velocidad * 1.3
	velocity = dir * v
	move_and_slide()

	
	if dir.x != 0:
		sprite.flip_h = dir.x < 0

func _rutina_ataque() -> void:
	
	while not muerto:
		var espera := 2.4 if fase == 1 else 1.6
		await get_tree().create_timer(espera).timeout
		if muerto:
			return
		if jugador != null and is_instance_valid(jugador):
			if fase == 1:
				_ataque_simple()
			else:
				_ataque_abanico()

func _ataque_simple() -> void:
	
	atacando = true
	sprite.play("atacar")
	var dir := (jugador.global_position - global_position).normalized()
	_disparar_bala(dir)
	await get_tree().create_timer(0.4).timeout
	atacando = false
	if not muerto:
		sprite.play("idle")

func _ataque_abanico() -> void:
	
	atacando = true
	sprite.play("atacar")
	var base_dir := (jugador.global_position - global_position).normalized()
	for angulo in [-0.3, 0.0, 0.3]:
		_disparar_bala(base_dir.rotated(angulo))
	await get_tree().create_timer(0.4).timeout
	atacando = false
	if not muerto:
		sprite.play("idle")

func _disparar_bala(dir: Vector2) -> void:
	var bala := BALA.instantiate()
	bala.global_position = global_position
	bala.direccion = dir
	bala.es_del_jugador = false
	bala.dano = 8
	bala.velocidad = 190.0
	get_tree().current_scene.add_child(bala)

func recibir_dano(cantidad: int) -> void:
	if muerto:
		return
	vida -= cantidad
	vida = max(vida, 0)
	vida_cambiada.emit(vida, vida_maxima)
	ScoreManager.sumar_puntos(50)

	
	sprite.modulate = Color(1, 0.4, 0.4)
	var t := create_tween()
	t.tween_property(sprite, "modulate", Color.WHITE, 0.2)

	
	if fase == 1 and vida <= vida_maxima * 0.4:
		fase = 2
		_aviso_fase_2()

	if vida <= 0:
		_morir()

func _aviso_fase_2() -> void:
	
	var t := create_tween()
	t.tween_property(sprite, "modulate", Color(1, 0.5, 0), 0.15)
	t.tween_property(sprite, "modulate", Color.WHITE, 0.15)
	t.set_loops(3)

func _morir() -> void:
	muerto = true
	velocity = Vector2.ZERO
	sprite.play("morir")
	ScoreManager.sumar_puntos(1000)


	var efecto := preload("res://scenes/EfectoMuerte.tscn").instantiate()
	efecto.global_position = global_position
	get_tree().current_scene.add_child(efecto)

	ha_muerto.emit()
