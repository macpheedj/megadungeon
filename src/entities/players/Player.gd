extends AnimatedSprite2D
class_name Player


@export var is_active = false

@export_group("Main")
@export var level: int = 1
@export var xp: int = 0
@export_enum("LAWFUL", "NEUTRAL", "CHAOTIC") var alignment: String

@export_group("Combat")
@export var health: int
@export var health_max: int
@export var defense: int
@export var defense_max: int
@export var block: float
@export var dodge: float
@export var movespeed: int

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
