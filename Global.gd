extends Node

const GAME_SAVE_PATH = "user://savegame.tscn" #"user://savegame.save"

var player_id:String
const save_data_mapping = {
	"PlayerID":"player_id"
}

var is_multiplayer:=false

var level_setup:Dictionary={
		"map_id":0,
		"pc1_id":0,
		"pc2_id":1
	}
var player:CharacterBody2D

func _init():
	load_game_save()
	#print("game save data: ",prepare_save_data())
	#if not "":
		#print("empty str")

func _ready():
	pass

func prepare_save_data()->Dictionary:
	var data:Dictionary={}
	for key in save_data_mapping:
		data[key] = self[save_data_mapping[key]]
	return data
	
func save_game():
	var save_scene:=PackedScene.new()
	var node :=Node.new()
	var node_data : Dictionary=prepare_save_data()
	for k in node_data:
		node.set_meta(k,node_data[k])
	save_scene.pack(node)
	ResourceSaver.save(save_scene,GAME_SAVE_PATH)

func load_game_save():
	if not FileAccess.file_exists(GAME_SAVE_PATH): 
		# Error! We don't have a save to load.
		var save_scene:=PackedScene.new()
		var node :=Node.new()
		save_scene.pack(node)
		ResourceSaver.save(save_scene,GAME_SAVE_PATH)
		node.free()
		return
	
	var game_save :Node= load(GAME_SAVE_PATH).instantiate()
	for key in save_data_mapping:
		if game_save.has_meta(key) :
			self[save_data_mapping[key]] = game_save.get_meta(key)
	game_save.free()

func load_json(path:String):
	if not FileAccess.file_exists(path):
		print("ERR:: load_json failed: %s not exist!"%path)
		return
	var f := FileAccess.open(path, FileAccess.READ)
	var json := JSON.new()
	var err:= json.parse(f.get_as_text())
	if err == OK:
		return json.get_data()
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", path, " at line ", json.get_error_line())
	
#static func get_absolute_z_index(target: Node2D) -> int:
	#var node = target;
	#var z_index = 0;
	#while node and node.is_class('Node2D'):
		#z_index += node.z_index;
		#if !node.z_as_relative:
			#break;
		#node = node.get_parent();
	#return z_index;
