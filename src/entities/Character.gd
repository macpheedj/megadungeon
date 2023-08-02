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


func _ready():
    if not stats == null:
        print("fart")
        print(name)
        stats.gain_level(self)
    else:
        print(stats)

    $JobComponent.setup()


func set_state(_state: State):
    print("[%s] setting state to %s" % [name, State.keys()[_state]])
    if not state == _state:
        state = _state
