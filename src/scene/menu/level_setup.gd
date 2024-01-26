extends Node2D

@onready var pc_1_container = %PC1Container
@onready var pc_2_container = %PC2Container
@onready var map_selection_container = %MapSelectionContainer

var res:={
	"Map":[],
	"Character":[]
}

enum RES {
	MAP,
	CHARACTER
}

var pc1_i : int=0:
	set(value):
		if value>=res.Character.size():
			pc1_i=0
		elif value<0:
			pc1_i=res.Character.size()-1
		else:pc1_i=value
		__setup_banner(pc_1_container, res.Character[pc1_i])
var pc2_i : int=0:
	set(value):
		if value>=res.Character.size():
			pc2_i=0
		elif value<0:
			pc2_i=res.Character.size()-1
		else: pc2_i=value
		__setup_banner(pc_2_container, res.Character[pc2_i])
var map_i : int=0:
	set(value):
		if value>= res.Map.size():
			map_i=0
		elif value<0:
			map_i= res.Map.size()-1
		else: map_i=value
		__setup_banner(map_selection_container, res.Map[map_i])

func _ready()->void:
	
	res.Map = __load_data_to_scene("res://data/map_config.json", RES.MAP)
	res.Character = __load_data_to_scene("res://data/character_config.json", RES.CHARACTER)

	__setup_banner(pc_1_container, res.Character[pc1_i])
	__setup_banner(pc_2_container, res.Character[pc2_i])
	__setup_banner(map_selection_container, res.Map[map_i])

func __load_data_to_scene(path:String, want:int)->Array:
	var data :Array= Global.load_json(path)
	var loaded :Array=[]
	var corp:Callable
	var field:String
	match want:
		RES.MAP:
			corp = __corp_banner_map
			field = "Background"
		RES.CHARACTER:
			corp = __corp_banner_char
			field = "Banner"
	for each in data:
		loaded.append({
			"ID":each.ID,
			"Name":each["Name"],
			"Texture":corp.call( load(each.ResPath[field]) )
		})
	return loaded


func __setup_banner(container:Node, res:Dictionary)->void:
	var bg:TextureRect = container.get_node("MarginContainer/TextureRectBackground")
	#print(len(res))
	bg.texture = res["Texture"]
	var infoNode:=container.get_node("MarginContainer/VBoxContainer/MarginContainer/HBoxContainer")
	#print(container.name)
	if "Map" in container.name:
		infoNode.get_child(0).text="地图"
	elif "PC1" in container.name:
		infoNode.get_child(0).text="%s 心蟠" % Global.player_id
	elif "PC2" in container.name:
		infoNode.get_child(0).text="大傩 心蟠"
	#infoNode.get_child(1).text=res[i].atlas.resource_path.split('/')[-1].split('_')[1]
	infoNode.get_child(1).text=res["Name"]

func __corp_banner_char(res:Texture2D)-> AtlasTexture:
	var atlas:AtlasTexture=AtlasTexture.new()
	atlas.atlas=res
	atlas.region=Rect2(10, 10, 1260, 190)
	return atlas

func __corp_banner_map(res:Texture2D)->AtlasTexture:
	var atlas:AtlasTexture=AtlasTexture.new()
	atlas.atlas=res
	atlas.region=Rect2(0, 520, 1260, 190)
	return atlas

func _on_to_back_pressed():
	get_tree().change_scene_to_file("res://src/scene/menu/init_menu.tscn")

func _on_btn_enter_level_pressed():
	Global.level_setup={
		"map_id":map_i,
		"pc1_id":pc1_i,
		"pc2_id":pc2_i
	}
	get_tree().change_scene_to_file("res://src/scene/level/level_main.tscn")
