extends Control


func _ready() -> void:
	get_tree().paused = false  
	AudioManager.musica_victoria()  
	$BotonJugar.pressed.connect(_jugar)
	$BotonSalir.pressed.connect(_salir)
	$BotonJugar.grab_focus()

func _jugar() -> void:
	ScoreManager.reiniciar()
	AudioManager.detener_musica()
	get_tree().change_scene_to_file("res://scenes/Nivel1.tscn")

func _salir() -> void:
	get_tree().quit()
