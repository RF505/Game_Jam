extends CanvasLayer
class_name UI_Hearts

@onready var hearts := [
	$HBoxContainer/Heart1,
	$HBoxContainer/Heart2,
	$HBoxContainer/Heart3
]

func update_hearts(current_health: int):
	for i in range(hearts.size()):
		hearts[i].visible = i < current_health
