extends Control

func _ready() -> void:
	AudioManager.musica_game_over()
	$BotonReintentar.pressed.connect(_reintentar)
	$BotonMenu.pressed.connect(_menu)
	$BotonReintentar.grab_focus()

func _reintentar() -> void:
	get_tree().paused = false
	ScoreManager.reiniciar()
	AudioManager.detener_musica()
	get_tree().change_scene_to_file("res://scenes/Nivel1.tscn")

func _menu() -> void:
	get_tree().paused = false
	AudioManager.detener_musica()
	get_tree().change_scene_to_file("res://scenes/MenuPrincipal.tscn")
