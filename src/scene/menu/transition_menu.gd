extends CanvasLayer

@export var is_from_multiplayer: = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_btn_back_pressed():
	if is_from_multiplayer:	
		pass # Replace with function body.
	else:
		get_tree().change_scene_to_file("res://src/scene/menu/init_menu.tscn")
	
