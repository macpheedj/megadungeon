# Combat handler for Floor class
extends Node


@export var dungeon_floor: Floor
var actors: Array[Character] = []


func prompt_initiative():
	pass


func begin_combat(encounter: Encounter):
	actors = []

	print("*****")
	print("*****")
	for player in dungeon_floor.get_node("Party").get_children():
		player.stats.gain_level()
		player.set_state(player.State.StandingBy)
		actors.push_back(player)
	
	for monster in encounter.get_node("Monsters").get_children():
		monster.stats.gain_level()
		monster.set_state(monster.State.StandingBy)
		monster.visible = true
		actors.push_back(monster)
