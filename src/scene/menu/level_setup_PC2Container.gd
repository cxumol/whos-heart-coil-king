extends NinePatchRect

var agent:Node2D

func _ready():
	agent=get_window().get_node("LevelSetup")

func _on_to_left_pressed():
	pass # Replace with function body.
	agent.pc2_i -= 1
	

func _on_to_right_pressed():
	agent.pc2_i += 1
	
