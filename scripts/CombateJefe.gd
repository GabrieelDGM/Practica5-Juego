extends Node2D


var fin_partida: bool = false

func _ready() -> void:
	AudioManager.musica_batalla()

	var jugador := $Agente
	var jefe := $Jefe
	var hud := $HUD

	hud.conectar_jugador(jugador)
	hud.conectar_jefe(jefe)

	jugador.ha_muerto.connect(_game_over)
	jefe.ha_muerto.connect(_victoria)

func _game_over() -> void:
	if fin_partida:
		return
	fin_partida = true
	ScoreManager.detener_tiempo()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func _victoria() -> void:
	if fin_partida:
		return
	fin_partida = true
	ScoreManager.detener_tiempo()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/Victoria.tscn")
