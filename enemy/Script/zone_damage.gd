extends RigidBody2D
class_name Zone_damage

var coli : CollisionShape2D

func _ready() -> void:
	coli = $CollisionShape2D
	
func traverse() -> void:
	coli.disabled = true  # désactive la collision
	await get_tree().create_timer(2.0).timeout  # attend 2 secondes
	coli.disabled = false
