extends Node
class_name MovementComponent


enum Direction { North, South, East, West }


const size := 16
@export var character: Character


func _ready():
	pass


func attempt_move(direction: Direction):
	match direction:
		Direction.North: character.position.y -= size
		Direction.South: character.position.y += size
		Direction.East: character.position.x += size
		Direction.West: character.position.x -= size


func _process(_delta):
	if not character.state == character.State.Adventuring:
		return

	if Input.is_action_just_pressed("move_north"): attempt_move(Direction.North)
	if Input.is_action_just_pressed("move_south"): attempt_move(Direction.South)
	if Input.is_action_just_pressed("move_east"): attempt_move(Direction.East)
	if Input.is_action_just_pressed("move_west"): attempt_move(Direction.West)
