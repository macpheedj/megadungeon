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


var corpse: SpriteFrames = preload("res://resources/sprite_frames/corpse.tres")
var blood_tiles: SpriteFrames = preload("res://resources/sprite_frames/BloodTile.tres")
var living_sprite: SpriteFrames


@export var character_type: CharacterType
@export var state: State
@export var stats: Stats

# default sprite facing == right
@export var facing: MovementComponent.Direction = MovementComponent.Direction.East
@export var is_alive := true


func _ready():
    setup_animation_library()

    if $JobComponent:
        $JobComponent.setup()


func set_state(_state: State):
    print("[%s] setting state to %s" % [name, State.keys()[_state]])
    if not state == _state:
        state = _state


func get_weapon_damage():
    return randi_range(1, 6)


func take_damage(damage: int):
    print("Ouch! [%s] just took %s damage" % [name, str(damage)])
    $Animator.play("take_damage")
    stats.health = clamp(stats.health - damage, 0, stats.max_health)

    if stats.health == 0:
        await get_tree().create_timer(0.3).timeout
        die()


func die():
    if not is_alive:
        return

    z_index = 10
    is_alive = false
    living_sprite = $Sprite.sprite_frames
    $Collision.disabled = true

    match character_type:
        CharacterType.Player:
            $Sprite.scale = Vector2(0.75, 0.75)
            $Sprite.position += Vector2(0, 2)
            $Sprite.sprite_frames = corpse
        
        CharacterType.Monster:
            $Sprite.sprite_frames = blood_tiles
            $Sprite.play(str(randi_range(1, 5)))


func revive(hit_points: int = 1):
    if is_alive:
        return

    z_index = 20
    is_alive = true
    stats.health = hit_points
    $Collision.disabled = false
    $Sprite.sprite_frames = living_sprite

    match character_type:
        CharacterType.Player:
            $Sprite.scale = Vector2(1.0, 1.0)
            $Sprite.position -= Vector2(0, 2)
        
        CharacterType.Monster:
            $Sprite.sprite_frames = blood_tiles
            $Sprite.play(str(randi_range(1, 5)))


func setup_animation_library():
    var animation = Animation.new()
    animation.length = 0.3
    animation.add_track(Animation.TYPE_VALUE)
    animation.track_set_path(0, ".:position")

    var animation_library = AnimationLibrary.new()
    animation_library.add_animation(name, animation)

    $Animator.add_animation_library("attacks", animation_library)


func animate_attack():
    var animation_name = "attacks/%s" % name
    var distance = 4
    var animations = {
        MovementComponent.Direction.North: Vector2(0, -distance),
        MovementComponent.Direction.South: Vector2(0, distance),
        MovementComponent.Direction.East: Vector2(distance, 0),
        MovementComponent.Direction.West: Vector2(-distance, 0),
    }
    var animation = $Animator.get_animation(animation_name)

    animation.track_insert_key(0, 0.0, position)
    animation.track_insert_key(0, 0.15, position + animations[facing])
    animation.track_insert_key(0, 0.3, position)
    
    $Animator.play(animation_name)
