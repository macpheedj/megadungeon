extends Node


@export var player: Entity
var size = 16


func _process(_delta):
	match player.state:
		player.State.StandingBy:
			return

		player.State.Adventuring:
			handle_adventuring_movement()
		
		player.State.TakingTurn:
			handle_turn_taking()


func handle_adventuring_movement():
	if Input.is_action_just_pressed("move_north"): player.position.y -= size
	if Input.is_action_just_pressed("move_south"): player.position.y += size
	if Input.is_action_just_pressed("move_east"): player.position.x += size
	if Input.is_action_just_pressed("move_west"): player.position.x -= size


func handle_turn_taking():
	if Input.is_action_just_pressed("action_bar_1"): player.perform_action(1)
	if Input.is_action_just_pressed("action_bar_2"): player.perform_action(2)
	if Input.is_action_just_pressed("action_bar_3"): player.perform_action(3)
	if Input.is_action_just_pressed("action_bar_4"): player.perform_action(4)
