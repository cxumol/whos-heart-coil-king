extends Node

@onready var background = %Background

func _ready():
	var mapID :int= Global.level_setup.map_id
	var map_data_all:Array = Global.load_json("res://data/map_config.json")
	background.texture = load(map_data_all[mapID].ResPath.Background)
