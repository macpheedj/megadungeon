# Combat handler for Floor class
extends Node


@export var dungeon_floor: Floor
var actors: Array[Character] = []
var waits: Array[Dictionary] = []


func prompt_initiative():
	pass


func character_priority_sort(a, b):
	if (a.wait == b.wait) and a.type == Character.CharacterType.Player:
		return true
	return a.wait > b.wait


func setup(encounter: Encounter):
	actors = []

	for character in dungeon_floor.get_node("Party").get_children() + encounter.get_node("Monsters").get_children():
		character.set_state(Character.State.StandingBy)
		actors.push_back(character)
		waits.push_back({
			name = character.name,
			type = character.character_type,
			wait = 1000 - character.stats.speed,
		})
	
	waits.sort_custom(func(a, b): return a.wait > b.wait)


func begin():
	tick_initiative()


func tick_initiative():
	var counting_down = true

	while counting_down:
		for actor in waits:
			actor.wait -= 1
			if actor.wait <= 0:
				print("time for %s's turn" % actor.name)
				counting_down = false
				pass
