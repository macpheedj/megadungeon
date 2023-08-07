extends Area2D
class_name Character


signal interaction_attempted
signal action_completed
signal turn_ended


enum CharacterType {
    Player,
    Neutral,
    Monster,
}

enum State {
    Adventuring,
    StandingBy,
    TakingTurn,
}


var corpse: SpriteFrames = preload("res://resources/corpse.tres")
var living_sprite: SpriteFrames


@export var character_type: CharacterType
@export var state: State
@export var stats: Stats
@export var job: Job

# default sprite facing == right
@export var facing: MovementComponent.Direction = MovementComponent.Direction.East
@export var is_alive := true


func _ready():
    $JobComponent.setup()
    stats.set_level(1)


func set_state(_state: State):
    print("[%s] setting state to %s" % [name, State.keys()[_state]])
    if not state == _state:
        state = _state


func get_weapon_damage():
    return 50


func take_damage(damage: int):
    print("Ouch! [%s] just took %s damage" % [name, str(damage)])
    $Animator.play("take_damage")
    stats.current_health = clamp(stats.current_health - damage, 0, stats.health)

    if stats.current_health == 0:
        await get_tree().create_timer(0.3).timeout
        die()


func die():
    z_index = 10
    is_alive = false
    living_sprite = $Sprite.sprite_frames
    $Sprite.scale = Vector2(0.75, 0.75)
    $Sprite.position += Vector2(0, 2)
    $Sprite.sprite_frames = corpse
    $Collision.disabled = true


func revive(hit_points: int = 1):
    z_index = 20
    is_alive = true
    stats.current_health = hit_points
    $Sprite.scale = Vector2(1.0, 1.0)
    $Sprite.position -= Vector2(0, 2)
    $Sprite.sprite_frames = living_sprite
    $Collision.disabled = false


func animate_attack():
    var distance = 4
    var animations = {
        MovementComponent.Direction.North: Vector2(0, -distance),
        MovementComponent.Direction.South: Vector2(0, distance),
        MovementComponent.Direction.East: Vector2(distance, 0),
        MovementComponent.Direction.West: Vector2(-distance, 0),
    }

    var animation = $Animator.get_animation("attack")
    animation.track_insert_key(0, 0.0, position)
    animation.track_insert_key(0, 0.15, position + animations[facing])
    animation.track_insert_key(0, 0.3, position)

    $Animator.play("attack")
