extends Action
class_name MoveAction


enum { NORTH, SOUTH, EAST, WEST }


var character: Character
var original_position: Vector2

@export var size := 16
@export var min_range := 1
@export var max_range := 1
@export var move_remaining := 0


func on_enter(_character: Character):
    print("[MoveAction] on_enter")
    print("[MoveAction %s] movespeed: %s" % [_character.name, _character.movespeed])
    character = _character
    max_range = _character.movespeed
    move_remaining = _character.movespeed
    original_position = character.position


func attempt_move(direction):
    var old_position = character.position

    if direction == NORTH: character.position.y -= size
    if direction == SOUTH: character.position.y += size
    if direction == EAST: character.position.x += size
    if direction == WEST: character.position.x -= size
	
    if not old_position == character.position:
        move_remaining -= 1
        print("spaces remaining: " + str(move_remaining))


func handle_targeting():
    if move_remaining > 0:
        if Input.is_action_just_pressed("move_north"): attempt_move(NORTH)
        if Input.is_action_just_pressed("move_south"): attempt_move(SOUTH)
        if Input.is_action_just_pressed("move_east"): attempt_move(EAST)
        if Input.is_action_just_pressed("move_west"): attempt_move(WEST)
    
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
