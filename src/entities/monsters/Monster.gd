extends Entity
class_name Monster


enum State {
    StandingBy,
    TakingTurn,
}
var state: State = State.StandingBy


func set_state(new_state: State):
    print("[%s] setting state: %s" % [name, State.keys()[new_state]])
    if not new_state is State:
        print("%s is not a State" % State.keys()[new_state])
        return

    state = new_state
