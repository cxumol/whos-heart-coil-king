extends Node

signal health_changed
signal dead

@export var health:float=100.0:
	set(val):
		var diff:= val-health
		if diff!=0:
			emit_signal("health_changed", diff)
			update_HUD({"health":val})
			health=val
		if val<=0:
			emit_signal("dead")
		
@export var mana:float=100
@export var manaType:String="法力"
@export var manaMax:float=100
@export var spriteSheet:Texture2D

#var _is_taking_damage:

@onready var is_player2:bool = owner.name == "PC2"
@onready var animation_player_effects: = %AnimationPlayerEffects
@onready var hitbox := $"../HitBox2D"
@onready var animated_sprite_2d = $"../AnimatedSprite2D"

var pc_id:int
var pc_name:String
var player:String
var character_config :Array= Global.load_json("res://data/character_config.json")
var is_PVE_enemy:bool

func _ready():
	if is_player2:
		pc_id = Global.level_setup.pc2_id
	else:
		pc_id = Global.level_setup.pc1_id
	is_PVE_enemy = is_player2 and not Global.is_multiplayer
	player = Global.player_id
	if is_PVE_enemy:
		player="大傩"
	spriteSheet=load(character_config[pc_id].ResPath.SpriteSheet)
	pc_name = character_config[pc_id].Name
	
	var character_data:Dictionary = Global.load_json("res://data/character_data.json")
	manaType = character_data[pc_name].manaType
	manaMax = character_data[pc_name].manaMax
	health = character_data[pc_name].health
	init_HUD(character_data[pc_name])

func _input(event:InputEvent)->void:
	if owner.allow_attack==false:
		return
	
	if event.is_action("skill_1"):
		#print(event)
		if Input.is_action_pressed("up"):
			hitbox.position.y=-30
		elif Input.is_action_pressed("down"):
			hitbox.position.y=100
		if animated_sprite_2d.flip_h==true:
			hitbox.position.x=-88
		else:
			hitbox.position.x=88
		animation_player_effects.play("attack")

#func _physics_process(delta):
	

func take_damage(msg:Dictionary)->void:
	if 'health' in msg:
		health -= msg.health
	owner.hurt_feedback()

### HUD ###

const HUD_PATH := {
	"health": "VBoxContainer/Ceiling/HPBar",
	"mana": "VBoxContainer/Floor/Line1/ManaAllContainer/MPBar",
	"mana1": "VBoxContainer/Floor/Line2/MPBar1",
	"mana2": "VBoxContainer/Floor/Line2/MPBar2",
	"player": "VBoxContainer/Ceiling/PlayerLable",
	"manaType":"VBoxContainer/Floor/Line1/ManaAllContainer/ManaLabel",
	"manaType1":"VBoxContainer/Floor/Line2/ManaLabel1",
	"manaType2":"VBoxContainer/Floor/Line2/ManaLabel2",
	"weaponSprite1":"VBoxContainer/Floor/Line1/Weapon1/TextureRect",
	"weaponSprite2":"VBoxContainer/Floor/Line1/Weapon2/TextureRect",
}

func init_HUD(my_character_data:Dictionary):
	var hud=owner.HUD
	var path=HUD_PATH
	var node = func (key)->Control:
		return hud.get_node(path[key])
		
	for key in ["mana2","manaType2"]:
		node.call(key).visible=false
	for key in ["mana1","mana2","mana"]:
		node.call(key).value=0
	node.call("health").value=my_character_data.health
	node.call("manaType").text=my_character_data.manaType
	node.call("manaType").text=my_character_data.manaType
	node.call("player").text="%s (%s)"%[player,pc_name]

# prefix HUD/HBoxContainer/HUD1 HUD2
func update_HUD(msg:Dictionary)->void:
	var hud=owner.HUD
	var path=HUD_PATH
	var progress_bar:=["health","mana","mana1","mana2"]
	for key in msg:
		# update progress bar
		if key in progress_bar:
			hud.get_node(path[key]).value=msg[key]
