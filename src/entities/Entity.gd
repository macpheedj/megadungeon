extends AnimatedSprite2D
class_name Entity


signal turn_ended


enum State {
    Adventuring,
    StandingBy,
    TakingTurn,
}


@export_group("Main")
@export var level: int = 1
@export var xp: int = 0
@export_enum("LAWFUL", "NEUTRAL", "CHAOTIC") var alignment: String

@export_group("Combat")
@export var health: int
@export var health_max: int
@export var defense: int
@export var defense_max: int
@export var block: float = 0.0
@export var dodge: float = 0.0
@export var movespeed: int = 4

@export_group("Attributes")
@export var strength: int
@export var dexterity: int
@export var constitution: int
@export var intelligence: int
@export var wisdom: int
@export var charisma: int

@export_group("Equipment") # TODO: these should be a Resource probably
@export var helmet: String
@export var torso: String
@export var gloves: String
@export var boots: String
@export var weapon: String
@export var off_hand: String


var is_active = false
var initiative = 0

var state: State = State.StandingBy


func set_state(new_state: State):
    print("[%s] setting state: %s" % [name, State.keys()[new_state]])
    if not new_state is State:
        print("%s is not a State" % State.keys()[new_state])
        return

    state = new_state


func save():
    return {
        "filename": get_scene_file_path(),
        "level": level,
        "xp": xp,
        "position_x": position.x,
        "position_y": position.y,

        "health": health,
        "health_max": health_max,
        "defense": defense,
        "defense_max": defense_max,
        "block": block,
        "dodge": dodge,
        "movespeed": movespeed,

        "strength": strength,
        "dexterity": dexterity,
        "constitution": constitution,
        "intelligence": intelligence,
        "wisdom": wisdom,
        "charisma": charisma,

        "initiative": initiative,
    }


func _ready():
    for component in get_children():
        if component is ActionComponent:
            component.entity_turn_ended.connect(_on_turn_ended)


func _on_turn_ended():
    turn_ended.emit()
