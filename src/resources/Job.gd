extends Resource
class_name Job

enum Scaling { S, A, B, C, F }

@export var job_title: String
@export var sprite_frames: SpriteFrames

@export_category("scaling")
@export var health_scaling := Scaling.F
@export var juice_scaling := Scaling.F
@export var might_scaling := Scaling.F
@export var piety_scaling := Scaling.F
@export var speed_scaling := Scaling.F

@export_category("job stats")
@export_range(4, 6) var move := 4 # no. squares per turn
@export_range(0, 100) var dodge := 0 # avoid phys damage
