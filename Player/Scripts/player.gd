class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.RIGHT
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 350.0
var gravity : float = 1000
var jump_force : float = -500
var state : String = "idle"

var is_jumping : bool = false
var is_crouching : bool = false

var dead : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export_group("Camera sync")
@export var camera_sync: Camera2D
@export var should_camera_sync: bool = true
@export_group("")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Directions
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	#Saut
	if Input.is_action_just_pressed("up") and is_on_floor():
		is_jumping = true
		velocity.y = jump_force
		state = "jumping"
		UpdateAnimation()
		
	#crouching
	elif Input.is_action_pressed("down") and is_on_floor(): 
		is_crouching = true
		state = "crouch"
		UpdateAnimation()
	
	else:
		is_crouching = false
	
	#empecher d'autre action while jumping
	if is_jumping:
		return
	
	#Mvt Horizon
	velocity.x = direction.x * move_speed
	
	if SetState() == true || SetDirection() == true:
		UpdateAnimation()
	pass


func _physics_process(delta: float) -> void:
	# Gravité (si on est pas sur le sol)
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Si on touche le sol après un saut
		if is_jumping:
			is_jumping = false
			state = "idle"
			UpdateAnimation()

	move_and_slide()


func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	
	if direction == Vector2.ZERO:
		return false

	# Mise à jour de la direction cardinale
	if abs(direction.x) > abs(direction.y):
		new_dir = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		new_dir = Vector2.DOWN if direction.y > 0 else Vector2.UP

	if new_dir != cardinal_direction:
		cardinal_direction = new_dir
		return true

	return false


func SetState() -> bool:
	if is_jumping or is_crouching:
		return false  # on ne change pas l'état pendant ces actions

	var new_state : String = "idle" if direction.x == 0 and direction.y == 0 else "walk"
	if new_state == state: 
		return false
	else: 
		state = new_state
		return true
	
func UpdateAnimation() -> void:
	animation_player.play(state + "_" + AnimDirection())

	if cardinal_direction == Vector2.LEFT:
		sprite.flip_h = true
	elif cardinal_direction == Vector2.RIGHT:
		sprite.flip_h = false

	
func AnimDirection() -> String:
	if state in ["jumping", "crouch"]:
		return "slide"  # même direction pour simplifier
	elif cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "slide"
