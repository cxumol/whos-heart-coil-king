extends BaseStateMachine
class_name CharacterStateMachine
enum PC_STATE_TYPE {
	IDLE, # 角色在等待玩家输入或者AI决策的状态
	WALK, # 角色正在行走的状态
	JUMP, # 角色正在跳跃的状态
	STAMP, # 角色正在落地时的状态
	RUSH, # 角色正在冲刺的状态
	ATTACK, # 角色正在执行攻击动作的状态，可能包括各种不同的攻击技能状态
	DEFEND, # 角色正在防御或格挡敌人攻击的状态
	BEING_HIT, # 角色被敌人攻击并受到伤害的状态
	KNOCKED_DOWN, # 角色被击倒在地的状态
	GETTING_UP, # 角色从倒地状态恢复起来的状态
}

var is_in_air: bool = 0
var jump_count = 0

class IdleState:
	extends BaseState
	func enter(msg: Dictionary = {}) -> void:
		pass
		agent.allow_input_to_move=true
		agent.add_to_group("Player")
	func phy_process(delta: float) -> void:
		if agent.jump_count!=0 and agent.is_on_floor():
			agent.jump_count=0
		agent.input_to_move_left_right(delta)
	func state_input(event: InputEvent)->void:
		if Input.is_action_just_pressed("jump") and agent.jump_count<agent.jump_max:
			agent.velocity.y = agent.JUMP_VELOCITY
			agent.jump_count+=1
			transition_to(PC_STATE_TYPE.JUMP)

class WalkState:
	extends BaseState

class JumpState:
	extends BaseState
	
	func phy_process(delta: float) -> void:
		if agent.is_on_floor():
			transition_to(PC_STATE_TYPE.IDLE)
	func state_input(event: InputEvent)->void:
		if Input.is_action_just_pressed("jump") and agent.jump_count<agent.jump_max:
			agent.velocity.y = agent.AIR_JUMP_VELOCITY
			agent.jump_count+=1
			transition_to(PC_STATE_TYPE.JUMP)
		if Input.is_action_just_pressed("down"):
			transition_to(PC_STATE_TYPE.STAMP)
			
class StampState:
	extends BaseState
	#var previous_jump_velocity :float
	func enter(msg: Dictionary = {}) -> void:
		pass
		#print("stamp")
		agent.get_node("%HitAnim").play("star")
		agent.allow_input_to_move=false
		agent.allow_attack=false
	func phy_process(delta: float) -> void:
		agent.velocity.y -= agent.JUMP_VELOCITY
		agent.velocity.x = 0
		if agent.is_on_floor():
			agent.animation_tree["parameters/playback"].travel("stamp")
	func exit()->void:
		agent.allow_attack=true
			
class RushState:
	extends BaseState

class AttackState:
	extends BaseState

class DefendState:
	extends BaseState

class BeingHitState:
	extends BaseState

class KnockedDownState:
	extends BaseState

class GettingUpState:
	extends BaseState

func _input(event : InputEvent):
	if is_run and states[current_state]:
		states[current_state].state_input(event)

func _ready():
	self.add_state(PC_STATE_TYPE.IDLE, IdleState.new(self))
	self.add_state(PC_STATE_TYPE.WALK, WalkState.new(self))
	self.add_state(PC_STATE_TYPE.JUMP, JumpState.new(self))
	self.add_state(PC_STATE_TYPE.STAMP, StampState.new(self))
	self.add_state(PC_STATE_TYPE.RUSH, RushState.new(self))
	self.add_state(PC_STATE_TYPE.ATTACK, AttackState.new(self))
	self.add_state(PC_STATE_TYPE.DEFEND, DefendState.new(self))
	self.add_state(PC_STATE_TYPE.BEING_HIT, BeingHitState.new(self))
	self.add_state(PC_STATE_TYPE.KNOCKED_DOWN, KnockedDownState.new(self))
	self.add_state(PC_STATE_TYPE.GETTING_UP, GettingUpState.new(self))
	


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "stamp":
		self.states[current_state].transition_to(PC_STATE_TYPE.IDLE)
		#print("OK")
