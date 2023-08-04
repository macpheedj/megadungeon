# Combat handler for Floor class
extends Node


@export var dungeon_floor: Floor
var actors: Array[Character] = []


func prompt_initiative():
	pass


func character_priority_sort(a, b):
	if (a.stats.wait == b.stats.wait) and a.character_type == Character.CharacterType.Player:
		return true
	return a.stats.wait > b.stats.wait


func setup(encounter: Encounter):
	actors = []

	for character in dungeon_floor.get_node("Party").get_children() + encounter.get_node("Monsters").get_children():
		character.set_state(Character.State.StandingBy)
		character.stats.reset_wait()
		actors.push_back(character)
	
	actors.sort_custom(character_priority_sort)


func begin():
	tick_initiative()


func tick_initiative():
	var counting_down = true

	while counting_down:
		for actor in actors:
			actor.stats.wait -= 1
			if actor.stats.wait <= 0:
				counting_down = false
				actor.stats.reset_wait()
				actor.set_state(Character.State.TakingTurn)
				break
