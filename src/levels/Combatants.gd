extends Node

signal loaded_combatants


var players: Array[Entity] = []
var enemies: Array[Entity] = []
var combatants: Array[Entity] = []
var initiative_index = 0


func setupCombatants():
	var save_data = getSaveData()
	loadPlayers(save_data.players)
	loadEnemies(save_data.enemies)
	rollInitiative()

	loaded_combatants.emit()


func getSaveData():
	var file = FileAccess.open("res://tests/test_level.json", FileAccess.READ)
	var data = file.get_as_text()
	var json = JSON.new()
	json.parse(data)
	return json.get_data()


func loadPlayers(player_data):
	var positions = [
		Vector2(24, 24),
		Vector2(40, 24),
		Vector2(24, 40),
		Vector2(40, 40),
	]
	players = loadEntities(player_data, positions)


func loadEnemies(enemy_data):
	var positions = [
		Vector2(24 * 3, 24 * 3),
		Vector2(40 * 3, 24 * 3),
		Vector2(24 * 3, 40 * 3),
		Vector2(40 * 3, 40 * 3),
	]
	enemies = loadEntities(enemy_data, positions)


func loadEntities(entity_data, positions):
	var entities: Array[Entity] = []

	for i in entity_data.size():
		var data = entity_data[i]
		var entity = load(data.filename).instantiate()
		entity.position = positions[i]

		for key in data.keys():
			if ["filename", "position_x", "position_y"].has(key):
				continue
			entity.set(key, data[key])
		
		entities.push_back(entity)
	
	return entities


func rollInitiative():
	combatants = enemies.duplicate()
	combatants.append_array(players.duplicate())

	for combatant in combatants:
		var initiative = randi_range(1, 20) + combatant.dexterity
		combatant.initiative = initiative

	combatants.sort_custom(func (a, b): return a.initiative >= b.initiative)


func isPlayerDefeat():
	var total_hp = players.reduce(func (sum, player): return sum + player.health, 0)
	return total_hp == 0


func isPlayerVictory():
	var total_hp = enemies.reduce(func (sum, enemy): return sum + enemy.health, 0)
	return total_hp == 0


func countLivingCombatants():
	return combatants.reduce(func (sum, combatant): if combatant.health > 0: return sum + 1 else: return sum, 0)

func _process(_delta):
	pass
