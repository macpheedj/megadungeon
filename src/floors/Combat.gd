# Combat handler for Floor class
extends Node


@export var dungeon_floor: Floor
var actors: Array[Character] = []


func prompt_initiative():
	pass


func begin_combat(encounter: Encounter):
	actors = []

	for player in dungeon_floor.get_node("Party").get_children():
		player.set_state(player.State.StandingBy)
		actors.push_back(player)
	
	for monster in encounter.get_node("Monsters").get_children():
		monster.set_state(monster.State.StandingBy)
		actors.push_back(monster)
