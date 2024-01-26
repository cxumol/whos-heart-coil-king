extends Label

@export var floatSpeed:Vector2=Vector2(0,-50)

func _process(delta):
	position+=floatSpeed*delta

func _on_timer_timeout():
	queue_free()
