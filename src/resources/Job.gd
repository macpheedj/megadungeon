extends Resource
class_name Job


@export var job_title: String
@export var sprite_frames: SpriteFrames

@export_range(3, 8) var health_growth := 3
@export_range(1, 3) var attribute_growth := 2
