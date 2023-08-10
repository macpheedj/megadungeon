# Combat handler for Floor class
extends Node


enum Turn {
	Fast,
	Slow,
	Monster,
}
enum WinCondition {
	None,
	Defeat,
	Victory,
}


const THRESHOLD := 10

@export var dungeon_floor: Floor

var actors: Array[Character] = []
var players: Array[Character] = []
var monsters: Array[Character] = []

var turn: Turn = Turn.Fast
var turns_to_end := 0


func setup(encounter: Encounter):
	monsters = []
	actors = []

	for character in dungeon_floor.get_node("Party").get_children() + encounter.get_node("Monsters").get_children():
		if character.character_type == Character.CharacterType.Monster:
			monsters.push_back(character)
		
		if character.character_type == Character.CharacterType.Player:
			players.push_back(character)

		character.set_state(Character.State.StandingBy)
		character.action_completed.connect(_on_action_completed)
		character.turn_ended.connect(_on_turn_ended)
		actors.push_back(character)


func start_next_turn():
	if turns_to_end > 0: turns_to_end -= 1
	if not turns_to_end == 0:
		print("[Combat] turns_to_end: %s" % str(turns_to_end))
		return
	
	print("[Combat] starting next turn: %s" % Turn.keys()[turn])

	match turn:
		Turn.Fast:
			turn = Turn.Monster
			for actor in players:
				if actor.stats.initiative >= THRESHOLD:
					print("[%s] %s taking fast turn" % [name, actor.name])
					turns_to_end += 1
					take_turn(actor)

		Turn.Slow:
			turn = Turn.Fast
			for actor in players:
				if actor.stats.initiative < THRESHOLD:
					print("[%s] %s taking slow turn" % [name, actor.name])
					turns_to_end += 1
					take_turn(actor)

		Turn.Monster:
			turn = Turn.Slow
			for actor in monsters:
				await get_tree().create_timer(0.1).timeout
				print("[%s] %s taking monster turn" % [name, actor.name])
				turns_to_end += 1
				take_turn(actor)
	
	if turns_to_end == 0:
		start_next_turn()
	

func begin():
	for actor in players:
		actor.stats.roll_initiative()
		print("[%s] initiative: %s" % [actor.name, str(actor.stats.initiative)])

	start_next_turn()


func get_player_positions() -> Array:
	var filter_dead = func(player: Character): return player.is_alive
	var map_positions = func(player: Character): return player.global_position
	return dungeon_floor.get_node("Party").get_children().filter(filter_dead).map(map_positions)


func take_turn(actor: Character):
	print("[%s] taking turn" % actor.name)
	if actor.has_node("AIComponent"):
		var ai_component = actor.get_node("AIComponent")
		var player_positions := get_player_positions()
		ai_component.feed_player_positions(player_positions)
	actor.set_state(Character.State.TakingTurn)


func check_win_condition() -> WinCondition:
	var player_hp = actors.reduce(
		func(accum, actor):
			if actor.character_type == Character.CharacterType.Player:
				return accum + actor.stats.health
			else: return accum, 0)
	var monster_hp = actors.reduce(
		func(accum, actor):
			if actor.character_type == Character.CharacterType.Monster:
				return accum + actor.stats.health
			else: return accum, 0)

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
			start_next_turn()
		WinCondition.Defeat:
			print("!!!!! defeat !!!!!")
			for monster in dungeon_floor.get_node("Party").get_children():
				monster.set_state(Character.State.Adventuring)
		WinCondition.Victory:
			print("!!!!! victory !!!!!")
			for player in dungeon_floor.get_node("Party").get_children():
				player.set_state(Character.State.Adventuring)


func _on_action_completed():
	var wincon: WinCondition = check_win_condition()

	match wincon:
		WinCondition.None:
			return
		WinCondition.Defeat:
			print("!!!!! defeat !!!!!")
			for monster in monsters:
				monster.set_state(Character.State.StandingBy)
		WinCondition.Victory:
			print("!!!!! victory !!!!!")
			for player in players:
				player.set_state(Character.State.Adventuring)
