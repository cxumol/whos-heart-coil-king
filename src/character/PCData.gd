extends Node

signal health_changed

@export var health:float=100.0:
	set(val):
		var diff:= val-health
		if diff!=0:
			emit_signal("health_changed", diff)
			health=val
		
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
var character_config :Array= Global.load_json("res://data/character_config.json")

func _ready():
	#print(owner.name, is_player2)
	if is_player2:
		pc_id = Global.level_setup.pc2_id
	else:
		pc_id = Global.level_setup.pc1_id
	spriteSheet=load(character_config[pc_id].ResPath.SpriteSheet)
	pc_name = character_config[pc_id].Name
	
	var character_data:Dictionary = Global.load_json("res://data/character_data.json")
	manaType = character_data[pc_name].manaType
	manaMax = character_data[pc_name].manaMax
	health = character_data[pc_name].health

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
