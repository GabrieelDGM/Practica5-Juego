extends Node2D
## Efecto de muerte - animacion grande que se autodestruye

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	
	var tex: Texture2D = preload("res://assets/sprites/effect_death.png")
	var frames := SpriteFrames.new()
	#
	frames.set_animation_speed("default", 12.0)
	frames.set_animation_loop("default", false)
	for i in range(6):
		var atlas := AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(i * 192, 0, 192, 192)
		frames.add_frame("default", atlas)
	sprite.sprite_frames = frames
	sprite.scale = Vector2(0.7, 0.7)
	sprite.play("default")
	sprite.animation_finished.connect(queue_free)
