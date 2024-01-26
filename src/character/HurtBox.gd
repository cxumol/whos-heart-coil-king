class_name HurtBox
extends Area2D

#@export var damage:=5
@onready var pc_data:Node = %PCData
@onready var animated_sprite_2d = %AnimatedSprite2D

func _init():
	collision_layer=0
	collision_mask=2
	monitoring=true

func _ready():
	connect("area_entered", _on_area_entered)
	
func _on_area_entered(hitbox:HitBox)->void:
	
	if hitbox==null:
		return
	var damage :float = hitbox.damage
	if pc_data.has_method("take_damage"):
		#print(hitbox)
		pc_data.take_damage({"health":damage})
		
