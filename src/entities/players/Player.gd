extends AnimatedSprite2D
class_name Player


@export var is_active = false

@export_group("Main")
@export_enum("WARRIOR", "WIZARD") var character_class: String
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
@export var left_hand: String
@export var right_hand: String
@export_group("")

func _init(player):
    character_class = player.character_class
    level = player.level || 1
    xp = player.xp || 0

    strength = player.strength || 0
    dexterity = player.dexterity || 0
    constitution = player.constitution || 0
    intelligence = player.intelligence || 0
    wisdom = player.wisdom || 0
    charisma = player.charisma || 0

    health = player.health || constitution
    health_max = player.health_max || health
    defense = player.defense || 0
    defense_max = player.defense_max || defense
    block = player.block || 0.0
    dodge = player.dodge || 0.0
    movespeed = player.movespeed || 4

    if player.position_x && player.position_y:
        position = Vector2(player.position_x, player.position_y)

func save():
    return {
        "character_class": character_class,
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
    }
