extends Entity
class_name Player


enum State {
    Adventuring,
    StandingBy,
    TakingTurn,
}
@export var state: State = State.Adventuring


func set_state(new_state: State):
    assert(new_state is State, "%s is not a State" % State.keys()[new_state])
    print("[%s] setting state: %s" % [name, State.keys()[new_state]])
    state = new_state
