extends Area2D


signal cuerpo_entro

var ya_activada: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if ya_activada:
		return
	if body.is_in_group("jugador"):
		ya_activada = true
		cuerpo_entro.emit()
