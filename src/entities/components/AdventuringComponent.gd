extends Node
class_name MovementComponent


enum Direction { North, South, East, West }


const size := 16
@export var character: Character


func is_movement_blocked(direction: Direction) -> bool:
	var positions = {
		Direction.North: Vector2(0, -size),
		Direction.South: Vector2(0, size),
		Direction.East: Vector2(size, 0),
		Direction.West: Vector2(-size, 0),
	}
	character.get_node("Ray").target_position = positions[direction]
	character.get_node("Ray").force_raycast_update()
	return character.get_node("Ray").is_colliding()


func set_character_animation(animation: String):
	var sprite: AnimatedSprite2D = character.get_node("Sprite")
	var frame = sprite.get_frame()
	var progress = sprite.get_frame_progress()

	sprite.play(animation)
	sprite.set_frame_and_progress(frame, progress)


func attempt_move(direction: Direction):
	if is_movement_blocked(direction):
		return

	match direction:
		Direction.North:
			set_character_animation("up")
			character.position.y -= size

		Direction.South:
			set_character_animation("down")
			character.position.y += size

		Direction.East:
			set_character_animation("right")
			character.position.x += size

		Direction.West:
			set_character_animation("left")
			character.position.x -= size



func _process(_delta):
	if not character.state == character.State.Adventuring:
		return

	if Input.is_action_just_pressed("move_north"): attempt_move(Direction.North)
	if Input.is_action_just_pressed("move_south"): attempt_move(Direction.South)
	if Input.is_action_just_pressed("move_east"): attempt_move(Direction.East)
	if Input.is_action_just_pressed("move_west"): attempt_move(Direction.West)
