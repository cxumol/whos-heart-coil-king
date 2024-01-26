extends BaseStateMachine
class_name EnemyStateMachine
enum ENEMY_STATE_TYPE {
	IDLE, # 敌人在等待AI决策的状态
	WALK, # 敌人正在行走的状态
	JUMP, # 敌人正在跳跃的状态
	ATTACK, # 敌人正在执行攻击动作的状态，可能包括各种不同的攻击技能状态
	DEFEND, # 敌人正在防御或格挡玩家攻击的状态
	BEING_HIT, # 敌人被玩家攻击并受到伤害的状态
	KNOCKED_DOWN, # 敌人被击倒在地的状态
	GETTING_UP, # 敌人从倒地状态恢复起来的状态
}


#@onready var player = agent.get_parent().get_tree().get_first_node_in_group("Player")
class BaseEnemyState:
	extends BaseState
	var JUMP_AT = 100 
	var WALK_AT = 50
	func jump():
		if agent.enemy_target.velocity.y<=0:
			agent.velocity.y = agent.JUMP_VELOCITY
			agent.jump_count+=1
			transition_to(ENEMY_STATE_TYPE.JUMP)
	func get_x_distance()->float:
		var player_pos = agent.enemy_target.global_position
		# 获取敌人的位置
		var enemy_pos = agent.global_position
		return player_pos.x - enemy_pos.x
	func get_y_distance()->float:
		var player_pos = agent.enemy_target.global_position
		# 获取敌人的位置
		var enemy_pos = agent.global_position
		return enemy_pos.y - player_pos.y
	
class IdleState:
	extends BaseEnemyState
	#var to_jump:=false
	#var to_walk:=false
	func enter(_msg: Dictionary = {}) -> void:
		agent.add_to_group("Enemy")
		agent.velocity.x=0
		agent.allow_attack=false
		agent.SPEED = agent.SPEED * 0.8
		#to_jump=false
		# AI logic to decide next action
	func phy_process(delta: float) -> void:
		if agent.jump_count!=0 and agent.is_on_floor():
			agent.jump_count=0
		if agent.velocity.x!=0:
			transition_to(ENEMY_STATE_TYPE.WALK)
		var x_distance := get_x_distance()
		
		if absf(x_distance)>100:
			transition_to(ENEMY_STATE_TYPE.WALK)
		elif absf(x_distance)<50 and get_y_distance()>JUMP_AT:
			jump()
		#else:
			#print(get_y_distance())

class WalkState:
	extends BaseEnemyState
	#var to_jump:=false
	# AI logic to move towards player
	func phy_process(delta: float) -> void:
		var x_distance := get_x_distance()
		if absf(x_distance)>WALK_AT:
			#print(x_distance)
			if agent.velocity.x==0:
				if x_distance>0:
					agent.velocity.x=agent.SPEED
				else:
					agent.velocity.x=-agent.SPEED
			else:
				move_toward(agent.velocity.x, 0, agent.SPEED)
		elif get_y_distance()>JUMP_AT:
			jump()
		else:
			transition_to(ENEMY_STATE_TYPE.IDLE)

class JumpState:
	extends BaseEnemyState
	func enter(_msg: Dictionary = {}) -> void:
		pass
	func phy_process(delta: float) -> void:
		if agent.is_on_floor():
			transition_to(ENEMY_STATE_TYPE.IDLE)
		#elif :
			#return
		else:
			agent.velocity.y += agent.gravity * delta
			#agent.move_and_slide()

class AttackState:
	extends BaseEnemyState
	# AI logic to attack player

class DefendState:
	extends BaseEnemyState
	# AI logic to defend player's attack

class BeingHitState:
	extends BaseEnemyState
	# AI logic to react to player's attack

class KnockedDownState:
	extends BaseEnemyState
	# AI logic to react to being knocked down

class GettingUpState:
	extends BaseEnemyState
	# AI logic to get up from being knocked down

func _ready():
	self.add_state(ENEMY_STATE_TYPE.IDLE, IdleState.new(self))
	self.add_state(ENEMY_STATE_TYPE.WALK, WalkState.new(self))
	self.add_state(ENEMY_STATE_TYPE.JUMP, JumpState.new(self))
	self.add_state(ENEMY_STATE_TYPE.ATTACK, AttackState.new(self))
	self.add_state(ENEMY_STATE_TYPE.DEFEND, DefendState.new(self))
	self.add_state(ENEMY_STATE_TYPE.BEING_HIT, BeingHitState.new(self))
	self.add_state(ENEMY_STATE_TYPE.KNOCKED_DOWN, KnockedDownState.new(self))
	self.add_state(ENEMY_STATE_TYPE.GETTING_UP, GettingUpState.new(self))

