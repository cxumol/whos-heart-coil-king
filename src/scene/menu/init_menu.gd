extends CanvasLayer

const CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
@onready var edit_si_ming_name:LineEdit = %edit_SiMing_name
@onready var v_box_c_default:VBoxContainer = %VBoxC_default
@onready var v_box_c_settings:VBoxContainer = %VBoxC_settings


var player_id:String:
	set(val):
		player_id = val
		player_id = player_id.strip_escapes()
		%VBoxC_default.get_node("SiMing_name").text = "尊敬的司命 %s: " % player_id

func _ready():
	if not Global.player_id:
		Global.player_id=generateRandomString(5)
	player_id = Global.player_id
	edit_si_ming_name.text = player_id

func generateRandomString(length: int) -> String:
	var randomString = ''
	var random = RandomNumberGenerator.new()
	random.randomize()
	for i in range(length):
		randomString += CHARS[random.randi() % CHARS.length()]
	return randomString

func _save_game():
	Global.player_id=player_id
	Global.save_game()

func _on_btn_game_setting_pressed()->void:
	%VBoxC_default.visible=false
	%VBoxC_settings.visible=true

func _on_btn_game_setting_back_pressed()->void:
	_save_game()
	%VBoxC_settings.visible=false
	%VBoxC_default.visible=true

func _on_edit_si_ming_name_text_changed(new_text : String):
	#var SiMing_name : String= %edit_SiMing_name.text
	player_id = new_text
	#print(SiMing_name)

func _on_btn_game_exit_pressed():
	get_tree().quit()

func _on_btn_game_pvp_pressed():
	get_tree().change_scene_to_file("res://src/scene/menu/transition_menu.tscn")

func save()->Dictionary:
	return {"playerID":player_id}
	



func _on_btn_game_pve_pressed():
	get_tree().change_scene_to_file("res://src/scene/menu/level_setup.tscn")
