extends Node
class_name ActionComponent


enum State {
	Selecting,
	Targeting,
	Executing,
}

@export var character: Character

@export var move_action: MoveAction
@export var attack_action: AttackAction
@export var job_action: Action
@export var item_action: Action
@export var equip_action: Action
@export var skip_action: Action

var action: Action
var state: State
var action_points := 2
var actions_taken := 0


func set_state(new_state: State):
	assert(new_state is State)
	print("[%s] setting state: %s" % [name, State.keys()[new_state]])
	state = new_state


func select_action(selected_action: Action):
	if selected_action == null:
		return

	if action:
		action.on_exit()
		action.back_pressed.disconnect(_on_back_pressed)
		action.action_completed.disconnect(_on_action_completed)
		action.action_state_changed.disconnect(_on_action_state_changed)

	action = selected_action
	action.on_enter(character)
	action.back_pressed.connect(_on_back_pressed)
	action.action_completed.connect(_on_action_completed)
	action.action_state_changed.connect(_on_action_state_changed)

	set_state(State.Targeting)


func handle_selection_input():
	if Input.is_action_just_pressed("action_bar_1"): select_action(move_action)
	if Input.is_action_just_pressed("action_bar_2"): select_action(attack_action)
	if Input.is_action_just_pressed("action_bar_3"): select_action(job_action)
	if Input.is_action_just_pressed("action_bar_4"): select_action(item_action)
	if Input.is_action_just_pressed("action_bar_5"): select_action(equip_action)
	if Input.is_action_just_pressed("action_bar_6"): select_action(skip_action)


func _process(_delta):
	if not character.state == character.State.TakingTurn:
		return
	
	match state:
		State.Selecting:
			handle_selection_input()
		State.Targeting:
			action.handle_targeting()
		State.Executing:
			action.handle_execution()


func _on_action_state_changed(new_state: State):
	set_state(new_state)


func _on_back_pressed():
	print("[%s] back button pressed" % name)
	match state:
		State.Targeting: set_state(State.Selecting)
		State.Executing: set_state(State.Targeting)


func _on_action_completed():
	actions_taken += 1

	if actions_taken >= action_points:
		character.turn_ended.emit()
	else:
		set_state(State.Selecting)
