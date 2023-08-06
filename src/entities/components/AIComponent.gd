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
		if ray.is_colliding() and ray.get_collider().character_type == Character.CharacterType.Player:
			return true

	return false

func select_action():
	if is_player_in_range():
		# attack the player
		print("[%s] Player in range" % character.name)
		action = AI.Attack
	else:
		# move toward closest player
		print("[%s] Player not in range" % character.name)
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

	for ray in rays:
		if ray.is_colliding() and ray.get_collider().character_type == Character.CharacterType.Player:
			target = ray.get_collider()
			break

	var damage = 5
	target.take_damage(damage)
	finish_action()


func find_closest_player() -> Vector2:
	player_positions.sort_custom(func(a, b): return (character.global_position - a).abs() <= (character.global_position - b).abs())
	return player_positions[0]


func find_closest_side(target_position: Vector2) -> MoveAttempt:
	var diff = (character.global_position - target_position).abs()
	if diff == Vector2(0, 16) or diff == Vector2(16, 0): return MoveAttempt.None
	elif diff.x == diff.y: print("[%s] COIN TOSS" % character.name); return [MoveAttempt.Vertical, MoveAttempt.Horizontal][randi_range(0, 1)] # coin toss on tie
	elif diff.x < diff.y: return MoveAttempt.Horizontal
	else: return MoveAttempt.Vertical


func find_farthest_side(target_position: Vector2) -> MoveAttempt:
	var diff = (character.global_position - target_position).abs()
	if diff == Vector2(0, 16) or diff == Vector2(16, 0): return MoveAttempt.None
	elif diff.x == diff.y: print("[%s] COIN TOSS" % character.name); return [MoveAttempt.Vertical, MoveAttempt.Horizontal][randi_range(0, 1)] # coin toss on tie
	elif diff.x > diff.y: return MoveAttempt.Horizontal
	else: return MoveAttempt.Vertical


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


func attempt_move(direction: MovementComponent.Direction) -> bool:
	set_character_animation(direction)

	if is_movement_blocked(direction):
		print("movement blocked")
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

	return true


func ring(index: int, array: Array):
	if index < 0:
		return array[-1]
	elif index >= array.size():
		return array[0]
	else:
		return array[index]


func get_attempt_directions(direction: MovementComponent.Direction) -> Array[MovementComponent.Direction]:
	var directions: Array[MovementComponent.Direction] = [
		MovementComponent.Direction.North,
		MovementComponent.Direction.East,
		MovementComponent.Direction.South,
		MovementComponent.Direction.West,
	]
	var direction_index = directions.find(direction)
	return [
		directions[direction_index],
		ring(direction_index - 1, directions),
		ring(direction_index + 1, directions),
	]


func run_at_closest_player():
	var target_position := find_closest_player()
	var use_closest := true

	for i in range(character.stats.move):
		await get_tree().create_timer(0.3).timeout

		var start_diff = (character.global_position - target_position).abs()
		var target_side = find_closest_side(target_position) if use_closest else find_farthest_side(target_position)
		var first_attempt: MovementComponent.Direction

		match target_side:
			MoveAttempt.None:
				print("[%s] adjacent to target, no need to move" % character.name)
				break

			MoveAttempt.Vertical:
				if target_position.y < character.global_position.y:
					first_attempt = MovementComponent.Direction.North
				elif target_position.y > character.global_position.y:
					first_attempt = MovementComponent.Direction.South
				elif target_position.x < character.global_position.x:
					first_attempt = MovementComponent.Direction.West
				elif target_position.x > character.global_position.x:
					first_attempt = MovementComponent.Direction.East

			MoveAttempt.Horizontal:
				if target_position.x < character.global_position.x:
					first_attempt = MovementComponent.Direction.West
				elif target_position.x > character.global_position.x:
					first_attempt = MovementComponent.Direction.East
				elif target_position.y < character.global_position.y:
					first_attempt = MovementComponent.Direction.North
				elif target_position.y > character.global_position.y:
					first_attempt = MovementComponent.Direction.South

		var attempt_directions = get_attempt_directions(first_attempt)

		for j in range(attempt_directions.size()):
			print("[%s] attempting move #%s in direction: %s" % [character.name, str(j), MovementComponent.Direction.keys()[attempt_directions[j]]])
			var is_success = attempt_move(attempt_directions[j])
			if is_success:
				break
		
		# if current algo doesn't give results, try another
		var end_diff = (character.global_position - target_position).abs()
		var assessment = end_diff < start_diff
		if not assessment:
			use_closest = not use_closest

	
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
