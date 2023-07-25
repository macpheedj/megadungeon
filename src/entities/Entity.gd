extends AnimatedSprite2D
class_name Entity


var Action = preload("res://resources/Action.gd")

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

@export_group("Actions")
@export var action_1: Action
@export var action_2: Action
@export var action_3: Action
@export var action_4: Action
@export var action_5: Action
@export var action_6: Action
@export var action_7: Action
@export var action_8: Action


var is_active = false
var initiative = 0


func _ready():
    setup_actions()


func setup_actions():
    var actions = [
        action_1,
        action_2,
        action_3,
        action_4,
        action_5,
        action_6,
        action_7,
        action_8,
    ]
    for action in actions:
        if action:
            action.inject(self)


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
