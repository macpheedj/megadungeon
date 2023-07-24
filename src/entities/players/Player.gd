extends Entity
class_name Player


enum State {
    Adventuring,
    StandingBy,
    TakingTurn,
}
var state: State = State.Adventuring


func set_state(new_state: State):
    print("[%s] setting state: %s" % [name, State.keys()[new_state]])
    if not new_state is State:
        print("%s is not a State" % State.keys()[new_state])
        return

    state = new_state

func perform_action(action_index: int):
    print("perform_action called on base class: %s" % str(action_index))
    pass
