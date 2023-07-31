# Combat handler for Floor class
extends Node


@export var dungeon_floor: Floor


func begin_combat(encounter: Encounter):
	for player in dungeon_floor.get_node("Party").get_children():
		player.set_state(player.State.StandingBy)
	
	for monster in encounter.get_node("Monsters").get_children():
		monster.set_state(monster.State.StandingBy)
		monster.visible = true
