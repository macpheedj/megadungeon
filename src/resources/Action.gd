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
