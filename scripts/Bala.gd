extends Area2D


@export var velocidad: float = 420.0
@export var dano: int = 10
var direccion: Vector2 = Vector2.RIGHT
var es_del_jugador: bool = true

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	
	var tex: Texture2D = preload("res://assets/sprites/projectiles.png")
	var atlas := AtlasTexture.new()
	atlas.atlas = tex
	
	var fila := 0 if es_del_jugador else 1
	atlas.region = Rect2(0, fila * 32, 128, 32)
	sprite.texture = atlas
	sprite.scale = Vector2(0.45, 0.45)
	rotation = direccion.angle()

	
	collision_layer = 0
	if es_del_jugador:
		collision_mask = 8 | 1   
	else:
		collision_mask = 2 | 1   #

	
	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(self):
		queue_free()

func _physics_process(delta: float) -> void:
	position += direccion * velocidad * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("recibir_dano"):
		body.recibir_dano(dano)
	else:
		
		AudioManager.sonido_impacto()
	_impactar()

func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("pared"):
		AudioManager.sonido_impacto()
		_impactar()

func _impactar() -> void:
	
	var efecto := preload("res://scenes/EfectoImpacto.tscn").instantiate()
	efecto.global_position = global_position
	get_tree().current_scene.add_child(efecto)
	queue_free()
