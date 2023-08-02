extends Resource
class_name Stats


@export_category("base")
@export var level := 0 # level
@export var health := 0: # max hp
    set(value): print("health (%s) to (%s)" % [str(health), str(value)])
@export var juice := 0: # max mana
    set(value): print("juice (%s) to (%s)" % [str(juice), str(value)])
@export var might := 0: # phys damage
    set(value): print("might (%s) to (%s)" % [str(might), str(value)])
@export var piety := 0: # spell damage
    set(value): print("piety (%s) to (%s)" % [str(piety), str(value)])
@export var speed := 0: # turn order
    set(value): print("speed (%s) to (%s)" % [str(speed), str(value)])
@export var move := 0 # squares per turn
@export_range(0, 100) var luck := 50 # proc chance

var current_health := 0
var current_juice := 0

@export_category("job")
@export_range(0, 100) var dodge := 0 # avoid phys damage

# reduce incoming spell damage of same type by % (?)
@export_category("affinities")
@export_range(0, 100) var blood_affinity := 50
@export_range(0, 100) var bile_affinity := 50
@export_range(0, 100) var phlegm_affinity := 50


func scale(scaling: Job.Scaling):
    match scaling:
        Job.Scaling.S: return randi_range(10, 12)
        Job.Scaling.A: return randi_range(8, 10)
        Job.Scaling.B: return randi_range(6, 8)
        Job.Scaling.C: return randi_range(4, 6)
        Job.Scaling.F: return randi_range(2, 4)


func gain_level(character: Character):
    level += 1

    health += scale(character.job.health_scaling)
    juice += scale(character.job.juice_scaling)
    might += scale(character.job.might_scaling)
    piety += scale(character.job.piety_scaling)
    speed += scale(character.job.speed_scaling)

    current_health = health
    current_juice = juice
