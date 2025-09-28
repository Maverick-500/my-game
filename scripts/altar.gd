extends Area2D

@export var stats_menu: Window

func _ready():
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		stats_menu.open_menu()
