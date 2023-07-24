extends Entity
class_name Monster


var STATES = {
    STANDING_BY = "STANDING_BY",
    TAKING_TURN = "TAKING_TURN",
}
var state = STATES.STANDING_BY


func set_state(new_state):
    print("[%s] setting state: %s" % [name, new_state])
    if new_state in STATES:
        state = new_state
