extends Node2D


func _ready() -> void:
	AudioManager.musica_batalla()
	$Puerta.cuerpo_entro.connect(_ir_al_jefe)

func _ir_al_jefe() -> void:
	AudioManager.sonido_impacto() 
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://scenes/CombateJefe.tscn")
