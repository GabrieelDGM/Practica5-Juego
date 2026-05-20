extends Node


var musica: AudioStreamPlayer
var sfx: AudioStreamPlayer


var snd_disparo := preload("res://assets/audio/agenteDisparo.wav")
var snd_impacto := preload("res://assets/audio/impactodepared.mp3")
var snd_muerte := preload("res://assets/audio/muerte.wav")
var snd_dano := preload("res://assets/audio/recibeDano.wav")
var mus_batalla := preload("res://assets/audio/musicabatallaprincipal.ogg")
var mus_gameover := preload("res://assets/audio/musicadegameover.ogg")
var mus_victoria := preload("res://assets/audio/victoria.ogg")

func _ready() -> void:
	
	musica = AudioStreamPlayer.new()
	musica.bus = "Master"
	add_child(musica)

	
	sfx = AudioStreamPlayer.new()
	sfx.bus = "Master"
	add_child(sfx)

func reproducir_musica(stream: AudioStream, loop: bool = true) -> void:
	if musica.stream == stream and musica.playing:
		return
	musica.stream = stream
	
	if stream is AudioStreamOggVorbis:
		stream.loop = loop
	musica.play()

func detener_musica() -> void:
	musica.stop()

func reproducir_sfx(stream: AudioStream) -> void:
	sfx.stream = stream
	sfx.play()


func sonido_disparo() -> void:
	reproducir_sfx(snd_disparo)

func sonido_impacto() -> void:
	reproducir_sfx(snd_impacto)

func sonido_muerte() -> void:
	reproducir_sfx(snd_muerte)

func sonido_dano() -> void:
	reproducir_sfx(snd_dano)

func musica_batalla() -> void:
	reproducir_musica(mus_batalla, true)

func musica_game_over() -> void:
	reproducir_musica(mus_gameover, false)

func musica_victoria() -> void:
	reproducir_musica(mus_victoria, false)
