# Combat handler for Floor class
extends Node


enum WinCondition {
	None,
	Defeat,
	Victory,
}


@export var dungeon_floor: Floor
var actors: Array[Character] = []


func character_priority_sort(a, b):
	if (a.stats.wait == b.stats.wait) and a.character_type == Character.CharacterType.Player:
		return true
	return a.stats.wait > b.stats.wait


func setup(encounter: Encounter):
	actors = []

	for character in dungeon_floor.get_node("Party").get_children() + encounter.get_node("Monsters").get_children():
		character.set_state(Character.State.StandingBy)
		character.turn_ended.connect(_on_turn_ended)
		character.stats.reset_wait()
		actors.push_back(character)
	
	actors.sort_custom(character_priority_sort)


func begin():
	tick_initiative()


func get_player_positions() -> Array:
	return dungeon_floor.get_node("Party").get_children().map(func(player): return player.global_position)


func take_turn(actor: Character):
	print("[%s] taking turn" % actor.name)
	if actor.has_node("AIComponent"):
		var ai_component = actor.get_node("AIComponent")
		var player_positions := get_player_positions()
		ai_component.feed_player_positions(player_positions)
	actor.stats.reset_wait()
	actor.set_state(Character.State.TakingTurn)


func tick_initiative():
	var counting_down = true

	while counting_down:
		for actor in actors:
			actor.stats.wait -= 1
			if actor.stats.wait <= 0:
				counting_down = false
				take_turn(actor)
				break


func check_win_condition() -> WinCondition:
	var player_hp = actors.reduce(
		func(accum, actor):
			if actor.character_type == Character.CharacterType.Player:
				return accum + actor.stats.current_health
			else: return accum, 0)
	var monster_hp = actors.reduce(
		func(accum, actor):
			if actor.character_type == Character.CharacterType.Monster:
				return accum + actor.stats.current_health
			else: return accum, 0)

	print("player_hp = " + str(player_hp))
	print("monster_hp = " + str(monster_hp))

	if monster_hp == 0:
		return WinCondition.Victory
	elif player_hp == 0:
		return WinCondition.Defeat
	else:
		return WinCondition.None


func _on_turn_ended():
	var wincon: WinCondition = check_win_condition()

	match wincon:
		WinCondition.None:
			tick_initiative()
		WinCondition.Defeat:
			print("!!!!! defeat !!!!!")
		WinCondition.Victory:
			print("!!!!! victory !!!!!")
