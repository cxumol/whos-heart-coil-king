extends NinePatchRect

var agent:Node2D

func _ready():
	agent=get_window().get_node('LevelSetup')
	print("test get_window().get_node()= ",agent.name)

func _on_to_left_pressed():
	pass # Replace with function body.
	agent.pc1_i -= 1

func _on_to_right_pressed():
	agent.pc1_i += 1

func _on_focus_entered():
	var info:Node=%Info
	info.text="司命正在挑选心蟠"
