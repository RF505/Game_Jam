extends RigidBody2D
class_name Enemy

var velocity : Vector2 = Vector2(-100,0)
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var particules : GPUParticles2D = $GPUParticles2D

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)

func die():
	velocity.x = 0
	velocity.y = -200
	anim.play("mort")
	particules.restart()
	particules.emitting = true
	
