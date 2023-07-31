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
@export var movespeed := 5


func set_state(_state: State):
    print("[%s] setting state to %s" % [name, State.keys()[_state]])
    if not state == _state:
        state = _state
