extends RigidBody2D
class_name Enemy

@export var velocity : Vector2 = Vector2(-100,0)
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var particules : GPUParticles2D = $GPUParticles2D


var a_gauche = true

func _physics_process(delta: float) -> void:
	var col : KinematicCollision2D = move_and_collide(velocity * delta)
	if col:
		if col.get_normal().abs().is_equal_approx(Vector2.RIGHT):
			$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
			velocity.x = -velocity.x

func die():
	gravity_scale = 1
	velocity.x = 0
	velocity.y = -200
	anim.play("mort")
	particules.restart()
	particules.emitting = true
	audio.play()
	
	
