extends Area2D
class_name Character


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


@export var character_type: CharacterType
@export var state: State
@export var stats: Stats
@export var job: Job

# default sprite facing == right
@export var facing: MovementComponent.Direction = MovementComponent.Direction.East


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
    stats.current_health = clamp(stats.current_health - damage, 0, stats.health)
