extends RigidBody2D

class_name Enemy

@export var horizontal_speed = 30
@export var vertical_speed = 100

var velocity: Vector2


@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D

func _process(delta):
	velocity.x = delta * - horizontal_speed
	move_and_collide(velocity)
	
func die():
	horizontal_speed = 0
	vertical_speed = 0
	animated_sprite_2d.play("dead")
