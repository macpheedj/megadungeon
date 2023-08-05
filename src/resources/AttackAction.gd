extends Action
class_name AttackAction


enum Element { None, Blood, Bile, Phlegm }
enum Targeting { Single, Multiple }
enum ReticleShape { Rect }

@export var element: Element = Element.None
@export var targeting: Targeting = Targeting.Single
@export var reticle_shape: ReticleShape
@export var reticle_width: int = 1
@export var reticle_height: int = 1
@export var min_range: int = 1
@export var max_range: int = 1

var character: Character
var reticle: Reticle
var target: Character


func on_enter(_character: Character):
	character = _character
	setup_reticle()


func setup_reticle():
	match reticle_shape:
		ReticleShape.Rect:
			reticle = character.get_node("Reticle") as Reticle
			reticle.show_rect(Vector2(reticle_width, reticle_height))


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


func select_point():
	pass


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
	
	if Input.is_action_just_pressed("ui_accept"):
		select_target()

	if Input.is_action_just_pressed("ui_cancel"):
		back_pressed.emit()


func handle_execution():
	pass
