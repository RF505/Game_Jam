extends Area2D

@onready var image: Sprite2D= $image_Maison

var est_passe = false

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	image.visible = false  # l’image est cachée au départ
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and not est_passe:  # adapte le nom de ton personnage
		image.visible = true
		get_tree().paused = true
		est_passe = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("activer"):
		get_tree().paused = false
		image.visible = false
