extends Node2D
## Efecto de impacto - animacion corta que se autodestruye

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	
	var tex: Texture2D = preload("res://assets/sprites/effect_impact.png")
	var frames := SpriteFrames.new()


	frames.set_animation_speed("default", 18.0)
	frames.set_animation_loop("default", false)
	for i in range(5):
		var atlas := AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(i * 128, 0, 128, 128)
		frames.add_frame("default", atlas)
	sprite.sprite_frames = frames
	sprite.scale = Vector2(0.4, 0.4)
	sprite.play("default")
	sprite.animation_finished.connect(queue_free)
