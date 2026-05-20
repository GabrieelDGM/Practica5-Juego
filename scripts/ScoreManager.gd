extends Node
var puntos: int = 0
var tiempo_inicio: float = 0.0
var tiempo_total: float = 0.0

func reiniciar() -> void:
	
	puntos = 0
	tiempo_inicio = Time.get_ticks_msec() / 1000.0
	tiempo_total = 0.0

func sumar_puntos(cantidad: int) -> void:
	puntos += cantidad
	if puntos < 0:
		puntos = 0

func detener_tiempo() -> void:
	
	tiempo_total = (Time.get_ticks_msec() / 1000.0	) - tiempo_inicio

func calcular_bonus_tiempo() -> int:

	var bonus := 2000 - int(tiempo_total) * 10
	return max(bonus, 0)

func puntuacion_final() -> int:
	return puntos + calcular_bonus_tiempo()
