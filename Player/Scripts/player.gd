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

@export var max_jumps : int = 1
var jump_count : int = 0

@export var dash_distance : float = 150.0
@export var dash_speed : float = 1000.0
@export var dash_cooldown : float = 0.5
var can_dash : bool = true
var is_dashing : bool = false


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export_group("Camera sync")
@export var camera_sync: Camera2D
@export var should_camera_sync: bool = true
@export_group("")


func _process(delta: float) -> void:
	# Directions
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# Dash
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing and not is_crouching and direction.x != 0:
		Dash()
	
	# Jump and Double
	if Input.is_action_just_pressed("up") and jump_count < max_jumps:
		is_jumping = true
		velocity.y = jump_force
		jump_count += 1
		state = "jumping"
		UpdateAnimation()
	
	# Crouch
	elif Input.is_action_pressed("down") and is_on_floor():
		is_crouching = true
		state = "crouch"
		UpdateAnimation()
	else:
		is_crouching = false
		
	# Pas d'action pendant le dash
	#if is_dashing:
		#return
		
	# Mouvement horizontal normal
	velocity.x = direction.x * move_speed
	
	if SetState() or SetDirection():
		UpdateAnimation()


func _physics_process(delta: float) -> void:
	# Gravité
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Reset du compteur de saut quand on touche le sol
		if jump_count > 0:
			jump_count = 0
			is_jumping = false
			if not is_dashing:
				state = "idle"
				UpdateAnimation()

	move_and_slide()


func Dash() -> void:
	is_dashing = true
	can_dash = false
	
	state = "dash"
	UpdateAnimation()
	
	var dash_dir = sign(direction.x)
	var target_x = global_position.x + (dash_dir * dash_distance)
	
	sprite.flip_h = dash_dir < 0
	
	var tween = create_tween()
	tween.tween_property(self, "global_position:x", target_x, dash_distance / dash_speed)
	tween.tween_callback(Callable(self, "_end_dash"))
	
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true


func _end_dash() -> void:
	is_dashing = false
	state = "idle"
	UpdateAnimation()


func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	
	if direction == Vector2.ZERO:
		return false

	if abs(direction.x) > abs(direction.y):
		new_dir = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		new_dir = Vector2.DOWN if direction.y > 0 else Vector2.UP

	if new_dir != cardinal_direction:
		cardinal_direction = new_dir
		return true

	return false


func SetState() -> bool:
	if is_jumping or is_crouching or is_dashing:
		return false

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
	if state in ["jumping", "crouch", "dash"]:
		return "slide"  # même anim pour les deux sens
	elif cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "slide"
