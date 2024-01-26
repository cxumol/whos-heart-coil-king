extends CharacterBody2D

@export var SPEED : float= 600.0
@export var JUMP_VELOCITY : float= -600.0
@export var AIR_JUMP_VELOCITY : float= -300.0
@export var jump_max:int = 3
@export var allow_input_to_move:bool = true
@export var allow_attack:bool = true
@export var opponent:CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var fsm : BaseStateMachine = $CharacterStateMachine

## behaviors
var direction : float = 0.0
var jump_count = 0
var animation_locker:bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## meta

var enemy_target:CharacterBody2D
func _ready():
	#print(Global.get_absolute_z_index(self))
	build_AnimatedSprite2D($PCData.spriteSheet)
	## Multiplayer
	if Global.is_multiplayer:
		print("multiplayer is coming soon! quit...")
		get_tree().quit()
		
	## If it's enemy, assign fsm as EnemyStateMachine
	if $PCData.is_player2 and not Global.is_multiplayer:
		#enemy_target = get_parent().get_tree().get_first_node_in_group("Player")
		enemy_target = opponent
		fsm = $EnemyStateMachine
	fsm.launch()
	
	animation_tree.active = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#input_to_move(delta)
	move_and_slide()
	update_pc_anim()

func build_AnimatedSprite2D(spriteSheet:Texture)->void:
	var animatedSprite := $AnimatedSprite2D
	var lpc :=LPCAnimatedSprite2D.new()
	animatedSprite.frames = lpc.CreateSprites(spriteSheet)
	lpc.queue_free()

func input_to_move_left_right(delta):
	
	if not allow_input_to_move:
		return
		
	## <= & =>
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("left", "right")
	if is_on_floor():
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta)
	# face direction
	
		
		
	## boucing wall
	#var collision_info = move_and_collide(velocity * delta)
	#if collision_info and velocity.x!=0:
		#velocity = velocity.bounce(collision_info.get_normal())
		#velocity *= 1.5
		#velocity.x = move_toward(velocity.x, velocity.x, 0)

func update_pc_anim():
	if animation_locker:
		return
	var anim_direction:=0
	if velocity.x < 0:
		animated_sprite.flip_h = true
		anim_direction=-1
	elif velocity.x > 0:
		animated_sprite.flip_h = false
		anim_direction=1
	else:
		anim_direction=0
	animation_tree.set("parameters/walks/blend_position", anim_direction)

func enemy_move_towards_player(delta):
	var to_jump = [EnemyStateMachine.ENEMY_STATE_TYPE.IDLE,
	EnemyStateMachine.ENEMY_STATE_TYPE.WALK]
	# 获取玩家的位置
	var player_pos = enemy_target.global_position
	# 获取敌人的位置
	var enemy_pos = self.global_position
	# 计算两者在x轴上的差值
	var direction = player_pos.x - enemy_pos.x
	if direction != 0:
		if fsm.current_state==EnemyStateMachine.ENEMY_STATE_TYPE.IDLE:
			fsm.states[fsm.current_state].transition_to(EnemyStateMachine.ENEMY_STATE_TYPE.WALK)
		# 判断移动方向
		if direction > 0:
			direction = 1
		elif direction < 0:
			direction = -1
	elif player_pos.y > enemy_pos.y:
		if fsm.current_state in to_jump:
			fsm.states[fsm.current_state].transition_to(EnemyStateMachine.ENEMY_STATE_TYPE.JUMP)
	# 计算新的x位置
	velocity.x *= direction
	# 更新敌人的x位置，保持y位置不变
	move_toward(velocity.x, player_pos, SPEED)

func hurt_feedback(step:=10):
	position.x+=sign(position.x-opponent.position.x)*step
	#move_toward(position.x, position.x+sign(position.x-opponent.position.x)*step, SPEED*0.8)
