extends Node
class_name JobComponent


@export var character: Character

@export var basic_job: Job
@export var expert_job: Job
@export var advanced_job: Job


func gain_job(_job: Job):
    character.get_node("Sprite").set_sprite_frames(_job.sprite_frames)
    character.get_node("Sprite").play("right")


func setup():
    if basic_job:
        gain_job(basic_job)
    
    if expert_job:
        gain_job(expert_job)
    
    if advanced_job:
        gain_job(advanced_job)
