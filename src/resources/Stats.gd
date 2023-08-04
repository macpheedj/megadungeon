extends Resource
class_name Stats


@export var character: Character


@export_category("base")
@export var level := 0
@export var health := 20: set = _set_health
@export var juice := 10: set = _set_juice
@export var might := 0: set = _set_might
@export var piety := 0: set = _set_piety
@export var speed := 0: set = _set_speed
@export_range(0, 100) var luck := 50

var current_health := 0
var current_juice := 0
var wait := 0

@export_category("job")
@export_range(4, 6) var move := 0 # no. squares per turn
@export_range(0, 100) var dodge := 0 # % avoid phys damage

# reduce incoming spell damage of same type by % (?)
@export_category("affinities")
@export_range(0, 100) var blood_affinity := 50
@export_range(0, 100) var bile_affinity := 50
@export_range(0, 100) var phlegm_affinity := 50


func _set_health(value):
    var gain = value - health
    health = clamp(value, 0, 9999)
    current_health = clamp(current_health + gain, 0, 9999)

func _set_juice(value):
    var gain = value - juice
    juice = clamp(value, 0, 255)
    current_juice = clamp(current_juice + gain, 0, 255)

func _set_might(value):
    might = clamp(value, 0, 999)

func _set_piety(value):
    piety = clamp(value, 0, 999)

func _set_speed(value):
    speed = clamp(value, 0, 999)


func print_stats():
    print("***** base stats *****")
    print("health: %s / %s" % [str(current_health), str(health)])
    print("juice:  %s / %s" % [str(current_juice), str(juice)])
    print("might:  %s" % str(might))
    print("piety:  %s" % str(piety))
    print("speed:  %s" % str(speed))
    print("***** job stats *****")
    print("move:   %s" % str(move))
    print("dodge:  %s" % str(dodge))
    print("***** affinities *****")
    print("blood:  %s" % str(blood_affinity))
    print("bile:   %s" % str(bile_affinity))
    print("phlegm: %s" % str(phlegm_affinity))
    print()


func scale(scaling: Job.Scaling):
    match scaling:
        Job.Scaling.S: return randi_range(20, 22)
        Job.Scaling.A: return randi_range(18, 20)
        Job.Scaling.B: return randi_range(16, 18)
        Job.Scaling.C: return randi_range(14, 16)
        Job.Scaling.F: return randi_range(12, 14)


func gain_level():
    level += 1

    health += scale(character.job.health_scaling)
    juice += scale(character.job.juice_scaling)
    might += scale(character.job.might_scaling)
    piety += scale(character.job.piety_scaling)
    speed += scale(character.job.speed_scaling)

    current_health = health
    current_juice = juice


func set_level(_level: int):
    if level >= _level:
        return
    
    for i in range(_level - level):
        gain_level()

    print_stats()


func reset_wait():
    wait = 1000 - speed
