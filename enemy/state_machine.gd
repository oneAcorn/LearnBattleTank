extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary  # 存储所有状态


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


## [param state] 发出transitioned信号的状态自身.
## [param new_state_name] 新状态名称
func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	var new_state = states.get(new_state_name)
	if not new_state:
		return
	#print("enemy %s from %s trans to %s" % [owner.name, state.name, new_state_name])
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
