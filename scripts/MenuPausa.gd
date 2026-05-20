extends CanvasLayer


func _ready() -> void:
	visible = false
	$Fondo/Caja/BotonContinuar.pressed.connect(_continuar)
	$Fondo/Caja/BotonMenu.pressed.connect(_ir_al_menu)

func _input(event: InputEvent) -> void:
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			_alternar_pausa()
			get_viewport().set_input_as_handled()

func _alternar_pausa() -> void:
	if get_tree().paused:
		_continuar()
	else:
		_pausar()

func _pausar() -> void:
	get_tree().paused = true
	visible = true
	$Fondo/Caja/BotonContinuar.grab_focus()

func _continuar() -> void:
	get_tree().paused = false
	visible = false

func _ir_al_menu() -> void:
	
	get_tree().paused = false
	AudioManager.detener_musica()
	get_tree().change_scene_to_file("res://scenes/MenuPrincipal.tscn")
