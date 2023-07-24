extends Entity
class_name Player


var STATES = {
    ADVENTURING = "ADVENTURING",
    STANDING_BY = "STANDING_BY",
    TAKING_TURN = "TAKING_TURN",
}
var state = STATES.ADVENTURING


func set_state(new_state):
    print("[%s] setting state: %s" % [name, new_state])
    if new_state in STATES:
        state = new_state

