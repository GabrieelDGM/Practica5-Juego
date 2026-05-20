extends CanvasLayer


@onready var barra_jugador: ProgressBar = $BarraJugador
@onready var barra_jefe: ProgressBar = $PanelJefe/BarraJefe
@onready var label_puntos: Label = $LabelPuntos
@onready var panel_jefe: Control = $PanelJefe

func _ready() -> void:
	panel_jefe.visible = false

func conectar_jugador(jugador: Node) -> void:
	jugador.vida_cambiada.connect(_actualizar_vida_jugador)
	_actualizar_vida_jugador(jugador.vida, jugador.vida_maxima)

func conectar_jefe(jefe: Node) -> void:
	panel_jefe.visible = true
	jefe.vida_cambiada.connect(_actualizar_vida_jefe)
	_actualizar_vida_jefe(jefe.vida, jefe.vida_maxima)

func _actualizar_vida_jugador(actual: int, maximo: int) -> void:
	barra_jugador.max_value = maximo
	barra_jugador.value = actual

func _actualizar_vida_jefe(actual: int, maximo: int) -> void:
	barra_jefe.max_value = maximo
	barra_jefe.value = actual

func _process(_delta: float) -> void:
	label_puntos.text = "PUNTOS: %06d" % ScoreManager.puntos
