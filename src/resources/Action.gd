extends Resource
class_name Action


signal back_pressed
signal action_state_changed
signal action_completed


enum Type {
    Move,
    Attack,
}


func on_enter(_character: Character):
    pass


func on_exit():
    pass


func handle_targeting():
    assert(false, "handle_targeting() called on action class")


func handle_execution():
    assert(false, "handle_execution() called on action class")
