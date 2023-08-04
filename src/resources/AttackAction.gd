extends Action
class_name AttackAction


var character: Character
var target: Character


func on_enter(_character: Character):
	character = _character


func set_facing(direction: MovementComponent.Direction):
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


func select_target():
	pass

func handle_targeting():
	if Input.is_action_just_pressed("move_north"):
		set_facing(MovementComponent.Direction.North)
	if Input.is_action_just_pressed("move_south"):
		set_facing(MovementComponent.Direction.South)
	if Input.is_action_just_pressed("move_east"):
		set_facing(MovementComponent.Direction.East)
	if Input.is_action_just_pressed("move_west"):
		set_facing(MovementComponent.Direction.West)
	
	if Input.is_action_just_pressed("ui_accept"): pass
	if Input.is_action_just_pressed("ui_cancel"): pass


func handle_execution():
	pass
