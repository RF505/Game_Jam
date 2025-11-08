extends RigidBody2D

class_name Enemy

@export var horizontal_speed = 30
@export var vertical_speed = 100


@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D

func _process(delta):
	position.x -= delta * horizontal_speed
	
func die():
	horizontal_speed = 0
	vertical_speed = 0
	animated_sprite_2d.play("dead")
