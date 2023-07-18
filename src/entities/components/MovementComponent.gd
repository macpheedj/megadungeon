extends Node


@export var player: Player
var size = 16


func _process(_delta):
	if not player.is_active: return

	if Input.is_action_just_pressed("move_north"): player.position.y -= size
	if Input.is_action_just_pressed("move_south"): player.position.y += size
	if Input.is_action_just_pressed("move_east"): player.position.x += size
	if Input.is_action_just_pressed("move_west"): player.position.x -= size
