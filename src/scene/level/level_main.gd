extends Node

@onready var background = %Background

func _ready():
	var mapID :int= Global.level_setup.map_id
	var map_data_all:Array = Global.load_json("res://data/map_config.json")
	background.texture = load(map_data_all[mapID].ResPath.Background)

func end_game(msg:Dictionary):
	$settlementScreen.find_child("Title").text="结束"
	var full_name=func(e):return "%s (%s)"%[e.player, e.pc_name]
	$settlementScreen.find_child("Content").text="%s 击败了 %s"%[full_name.call(msg.winner), full_name.call(msg.loser)]
	$settlementScreen.visible=true
	get_tree().paused=true
	

func _on_pc_1_dead():
	end_game({"winner":$PC2/PCData, "loser":$PC1/PCData})

func _on_pc_2_dead():
	end_game({"winner":$PC1/PCData, "loser":$PC2/PCData})
