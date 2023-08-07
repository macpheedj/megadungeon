extends Action
class_name AttackAction


enum Element { None, Blood, Bile, Phlegm }
enum Targeting { Single, Multiple, Self }
enum ReticleShape { Rect }

const tile_size := 16

@export var element: Element = Element.None
@export var targeting: Targeting = Targeting.Single
@export var reticle_shape: ReticleShape
@export var reticle_width: int = 1
@export var reticle_height: int = 1
@export var min_range: int = 1
@export var max_range: int = 1

var character: Character
var reticle: Reticle
var targets: Array[Area2D] = []
var stay_execution := false


func on_enter(_character: Character):
	character = _character
	setup_reticle()
	character.get_node("RangeRay").apply_scale(Vector2(max_range, max_range))


func cleanup():
	stay_execution = false
	reticle.hide_rect()
	reticle = null
	targets = []


func setup_reticle():
	match reticle_shape:
		ReticleShape.Rect:
			reticle = character.get_node("Reticle") as Reticle
			reticle.show_rect(Vector2(reticle_width, reticle_height))

			var attack_range = Vector2(min_range, max_range)
			var size_by_range = {
				Vector2(1, 1): "Size1",
				Vector2(1, 2): "Size2",
				Vector2(2, 3): "Size2Offset1",
			}
			reticle.get_node(size_by_range[attack_range]).visible = true


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


func is_reticle_in_range(position: Vector2):
	var pos_diff = position - character.position
	var ray: RayCast2D = character.get_node("RangeRay")
	ray.look_at(position)
	var ray_diff = ray.to_global(ray.target_position) - character.position
	var diff = pos_diff.abs() - ray_diff.abs()
	return Vector2(int(diff.x), int(diff.y)) <= Vector2(0, 0)


func move_reticle(direction: MovementComponent.Direction):
	var cursor = reticle.get_node("Cursor")
	var vector_direction = {
		MovementComponent.Direction.North: Vector2(0, -1),
		MovementComponent.Direction.South: Vector2(0, 1),
		MovementComponent.Direction.East: Vector2(1, 0),
		MovementComponent.Direction.West: Vector2(-1, 0),
	}
	cursor.global_position += (vector_direction[direction] * tile_size)

	if (
		(direction == MovementComponent.Direction.North and (cursor.global_position.y < character.global_position.y)) or
		(direction == MovementComponent.Direction.South and (cursor.global_position.y >= character.global_position.y)) or
		(direction == MovementComponent.Direction.East and (cursor.global_position.x >= character.global_position.x)) or
		(direction == MovementComponent.Direction.West and (cursor.global_position.x < character.global_position.x))
	):
		set_facing(direction)


func select_target():
	if not is_reticle_in_range(reticle.get_node("Cursor").global_position):
		return

	var no_friendly_fire = func(t): return t.character_type != Character.CharacterType.Player
	targets = reticle.get_node("Cursor").get_overlapping_areas().filter(no_friendly_fire)
	if targets.size() == 0:
		return
	
	action_state_changed.emit(ActionComponent.State.Executing)
	reticle.get_node("Cursor").global_position = character.global_position


func handle_targeting():
	if Input.is_action_just_pressed("move_north"):
		move_reticle(MovementComponent.Direction.North)
	if Input.is_action_just_pressed("move_south"):
		move_reticle(MovementComponent.Direction.South)
	if Input.is_action_just_pressed("move_east"):
		move_reticle(MovementComponent.Direction.East)
	if Input.is_action_just_pressed("move_west"):
		move_reticle(MovementComponent.Direction.West)
	
	if Input.is_action_just_pressed("ui_accept"):
		select_target()

	if Input.is_action_just_pressed("ui_cancel"):
		cleanup()
		back_pressed.emit()


func handle_execution():
	if stay_execution:
		return

	stay_execution = true

	character.animate_attack()
	var damage = character.get_weapon_damage()
	for target in targets:
		target.take_damage(damage)

	cleanup()
	action_completed.emit()
