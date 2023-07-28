extends Node


enum State {
	Selecting,
	Targeting,
	Executing,
}

@export var entity: Entity

@export var action_1: Action
@export var action_2: Action
@export var action_3: Action
@export var action_4: Action
@export var action_5: Action
@export var action_6: Action
@export var action_7: Action
@export var action_8: Action

var action: Action
var state: State


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

	action = selected_action
	action.on_enter(entity)
	action.back_pressed.connect(_on_back_pressed)

	set_state(State.Targeting)


func handle_selection_input():
	if Input.is_action_just_pressed("action_bar_1"): select_action(action_1)
	if Input.is_action_just_pressed("action_bar_2"): select_action(action_2)
	if Input.is_action_just_pressed("action_bar_3"): select_action(action_3)
	if Input.is_action_just_pressed("action_bar_4"): select_action(action_4)
	if Input.is_action_just_pressed("action_bar_5"): select_action(action_5)
	if Input.is_action_just_pressed("action_bar_6"): select_action(action_6)
	if Input.is_action_just_pressed("action_bar_7"): select_action(action_7)
	if Input.is_action_just_pressed("action_bar_8"): select_action(action_8)


func _process(_delta):
	if not entity.state == entity.State.TakingTurn:
		pass
	
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
	print("back button pressed")
	match state:
		State.Targeting: set_state(State.Selecting)
		State.Executing: set_state(State.Targeting)
