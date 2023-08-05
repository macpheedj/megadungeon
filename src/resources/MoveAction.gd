extends Action
class_name MoveAction


var character: Character
var original_position: Vector2

@export var size := 16
@export var min_range := 1
@export var max_range := 1
@export var move_remaining := 0


func on_enter(_character: Character):
	print("[MoveAction] on_enter")
	print("[MoveAction %s] move: %s" % [_character.name, _character.stats.move])
	character = _character
	max_range = _character.stats.move
	move_remaining = _character.stats.move
	original_position = character.position


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
		print("movement blocked")
		return

	match direction:
		MovementComponent.Direction.North:
			character.position.y -= size

		MovementComponent.Direction.South:
			character.position.y += size

		MovementComponent.Direction.East:
			character.position.x += size

		MovementComponent.Direction.West:
			character.position.x -= size
	
	move_remaining -= 1
	print("spaces remaining: " + str(move_remaining))


func handle_targeting():
	if move_remaining > 0:
		if Input.is_action_just_pressed("move_north"):
			attempt_move(MovementComponent.Direction.North)
		if Input.is_action_just_pressed("move_south"):
			attempt_move(MovementComponent.Direction.South)
		if Input.is_action_just_pressed("move_east"):
			attempt_move(MovementComponent.Direction.East)
		if Input.is_action_just_pressed("move_west"):
			attempt_move(MovementComponent.Direction.West)
	
	if Input.is_action_just_pressed("ui_accept"):
		action_state_changed.emit(ActionComponent.State.Executing)

	if Input.is_action_just_pressed("ui_cancel"):
		if move_remaining < max_range:
			character.position = original_position
			move_remaining = max_range
		else:
			back_pressed.emit()


func handle_execution():
	# nothing to execute on a move action
	action_completed.emit()
