extends RefCounted
class_name BaseState

var state_machine : BaseStateMachine = null
var agent: Node :
	get:
		assert (state_machine and state_machine.agent, 'MISSING state_machine OR agent')
		return state_machine.agent

func _init(machine:BaseStateMachine) -> void:
	state_machine = machine

func enter(msg: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func process(delta: float) -> void:
	pass
	
func phy_process(delta: float) -> void:
	pass

func state_input(event : InputEvent):
	pass

func transition_to(state: int, msg: Dictionary = {}) -> void:
	state_machine.states[state_machine.current_state].exit()
	state_machine.current_state = state
	state_machine.states[state_machine.current_state].enter(msg)
