extends Node
class_name JobComponent


@export var character: Character


func change_job(_job: Job):
    character.job = _job
    character.get_node("Sprite").set_sprite_frames(_job.sprite_frames)
    character.get_node("Sprite").play("right")
    character.stats.dodge = _job.dodge


func setup():
    change_job(character.job)
