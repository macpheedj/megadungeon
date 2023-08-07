extends Node
class_name AIComponent


enum State {
	SelectingAction,
	ExecutingAction,
}
enum AI {
	None,
	Move,
	Attack,
}
enum MoveAttempt {
	None,
	Vertical,
	Horizontal,
}


const size := 16

@export var character: Character

var is_acting := false
var action: AI = AI.None
var state: State = State.SelectingAction
var action_points := 2
var actions_taken := 0
var player_positions: Array = []


func finish_action():
	actions_taken += 1

	if actions_taken >= action_points:
		action = AI.None
		actions_taken = 0
		character.set_state(Character.State.StandingBy)
		character.turn_ended.emit()

	state = State.SelectingAction
	is_acting = false


func is_player_in_range():
	var rays = [
		character.get_node("TargetNorth"),
		character.get_node("TargetSouth"),
		character.get_node("TargetEast"),
		character.get_node("TargetWest"),
	]

	for ray in rays:
		if ray.is_colliding():
			var object = ray.get_collider()
			if object is Character and object.character_type == Character.CharacterType.Player:
				return true

	return false

func select_action():
	if is_player_in_range():
		action = AI.Attack
	else:
		action = AI.Move
	
	state = State.ExecutingAction


func attack_player_in_range():
	var target: Character
	var rays = [
		character.get_node("TargetNorth"),
		character.get_node("TargetSouth"),
		character.get_node("TargetEast"),
		character.get_node("TargetWest"),
	]
	var facing_by_ray = {
		"TargetNorth": MovementComponent.Direction.North,
		"TargetSouth": MovementComponent.Direction.South,
		"TargetEast": MovementComponent.Direction.East,
		"TargetWest": MovementComponent.Direction.West,
	}

	for ray in rays:
		if ray.is_colliding() and ray.get_collider().character_type == Character.CharacterType.Player:
			target = ray.get_collider()
			set_character_animation(facing_by_ray[ray.name])
			break

	var damage = 5
	target.take_damage(damage)
	character.animate_attack()
	finish_action()


func find_shortest_distance(array: Array, vector: Vector2) -> Vector2:
	array.sort_custom(func(a, b): return a.distance_to(vector) < b.distance_to(vector))
	return array[0]


func is_movement_blocked(direction: MovementComponent.Direction) -> bool:
	var positions = {
		MovementComponent.Direction.North: Vector2(0, -size),
		MovementComponent.Direction.South: Vector2(0, size),
		MovementComponent.Direction.East: Vector2(size, 0),
		MovementComponent.Direction.West: Vector2(-size, 0),
	}
	character.get_node("MoveRay").target_position = positions[direction]
	character.get_node("MoveRay").force_raycast_update()
	return character.get_node("MoveRay").is_colliding()


func set_character_animation(direction: MovementComponent.Direction):
	var facing_directions = {
		MovementComponent.Direction.North: "up",
		MovementComponent.Direction.South: "down",
		MovementComponent.Direction.East: "right",
		MovementComponent.Direction.West: "left",
	}
	var animation = facing_directions[direction]
	var sprite: AnimatedSprite2D = character.get_node("Sprite")
	var frame = sprite.get_frame()
	var progress = sprite.get_frame_progress()

	sprite.play(animation)
	sprite.set_frame_and_progress(frame, progress)
	character.facing = direction


func attempt_move(direction: MovementComponent.Direction):
	set_character_animation(direction)

	if is_movement_blocked(direction):
		print("[%s] movement blocked direction: %s" % [character.name, MovementComponent.Direction.keys()[direction]])
		return false

	match direction:
		MovementComponent.Direction.North:
			character.position.y -= size

		MovementComponent.Direction.South:
			character.position.y += size

		MovementComponent.Direction.East:
			character.position.x += size

		MovementComponent.Direction.West:
			character.position.x -= size


func ring(index: int, array: Array):
	if index < 0:
		return array[-1]
	elif index >= array.size():
		return array[0]
	else:
		return array[index]


func run_at_closest_player():
	var target_position := find_shortest_distance(player_positions, character.global_position)

	for i in range(character.stats.move):
		print("[%s] move #%s" % [character.name, i])
		await get_tree().create_timer(0.3).timeout

		var diff = (character.global_position - target_position).abs()
		if diff == Vector2(0, size) or diff == Vector2(size, 0):
			break
		
		var direction_vectors = {
			MovementComponent.Direction.North: character.global_position + Vector2(0, -size),
			MovementComponent.Direction.South: character.global_position + Vector2(0, size),
			MovementComponent.Direction.East: character.global_position + Vector2(size, 0),
			MovementComponent.Direction.West: character.global_position + Vector2(-size, 0),
		}

		var moves = []

		for direction in direction_vectors:
			if not is_movement_blocked(direction):
				moves.push_back(direction_vectors[direction])

		var closest_position := find_shortest_distance(moves.map(func(move): return move), target_position)
		var best_move_direction: MovementComponent.Direction = direction_vectors.find_key(closest_position)

		attempt_move(best_move_direction)

	finish_action()


func execute_action():
	is_acting = true

	match action:
		AI.Attack:
			await get_tree().create_timer(0.5).timeout
			attack_player_in_range()
		AI.Move:
			await get_tree().create_timer(0.5).timeout
			run_at_closest_player()

	character.action_completed.emit()

func feed_player_positions(positions: Array):
	player_positions = positions


func _process(_delta):
	if is_acting or not character.state == Character.State.TakingTurn:
		return

	match state:
		State.SelectingAction:
			select_action()
		State.ExecutingAction:
			execute_action()
