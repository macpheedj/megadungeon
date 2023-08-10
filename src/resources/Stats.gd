extends Resource
class_name Stats

@export_category("Base Stats")

@export var health := 10
@export var max_health := 10
@export var juice := 10
@export var max_juice := 10
@export var defense := 10
@export var perception := 10
@export var move := 5

@export_category("Attributes")

@export var might := 10: set = _set_might
@export var agility := 10: set = _set_agility
@export var intellect := 10: set = _set_intellect
@export var piety := 10: set = _set_piety


func get_might_mod(): return might - 10
func get_agility_mod(): return agility - 10
func get_intellect_mod(): return intellect - 10
func get_piety_mod(): return piety - 10


var initiative := 0
func roll_initiative():
    initiative = get_agility_mod() + randi_range(1, 20)


# assumes attrs only increase
func _set_might(value: int):
    var gain = value - might

    might = value
    health += gain
    max_health += gain


func _set_agility(value: int):
    var gain = value - might

    agility = value
    defense += gain


func _set_intellect(value: int):
    var gain = value - might

    intellect = value
    perception += gain


func _set_piety(value: int):
    var gain = value - might

    piety = value
    juice += gain
    max_juice += gain


func print_stats():
    print("********** base stats **********")

    print("health: %s / %s" % [str(health), str(max_health)])
    print("juice: %s / %s" % [str(juice), str(max_juice)])
    print("defense: %s" % str(defense))
    print("perception: %s" % str(perception))
    print("move: %s" % str(move))

    print("********** attributes **********")

    print("might: %s (%s)" % [str(might), str(get_might_mod())])
    print("agility: %s (%s)" % [str(agility), str(get_agility_mod())])
    print("intellect: %s (%s)" % [str(intellect), str(get_intellect_mod())])
    print("piety: %s (%s)" % [str(piety), str(get_piety_mod())])
