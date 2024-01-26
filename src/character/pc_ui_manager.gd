extends Node

enum HINT { HP, MP }

@export var data_changed_lable:PackedScene=preload("res://src/character/UIFloatHint.tscn")
@export var heal_color:Color
@export var damage_color:Color
@export var mana_refill_color:Color
@export var mana_consume_color:Color

func _ready():
	#print(RenderingServer.CANVAS_ITEM_Z_MAX)
	pass

func spwan_float_hint(node:Node,type:HINT,diff:float)->void:
	if node==null:
		node=self
	var label:Label=data_changed_lable.instantiate()
	node.add_child(label)
	
	label.text= "%d"%diff
	
	var color:Color
	if type==HINT.HP:
		if diff>0:
			color=heal_color
		elif diff<0:
			color=damage_color
	label.add_theme_color_override("front_color", color)
	
	


func _on_pc_data_health_changed(diff:float):
	#print(diff)
	spwan_float_hint(self,HINT.HP,diff)
