extends Node

signal loaded_players
signal loaded_enemies


func _ready():
	var save_data = getSaveData()
	loadPlayers(save_data.players)
	loadEnemies(save_data.enemies)
	# establish initiative order
	# begin turns
	pass


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
	var players = loadEntities(player_data, positions)
	loaded_players.emit(players)


func loadEnemies(enemy_data):
	var positions = [
		Vector2(24 * 3, 24 * 3),
		Vector2(40 * 3, 24 * 3),
		Vector2(24 * 3, 40 * 3),
		Vector2(40 * 3, 40 * 3),
	]
	var enemies = loadEntities(enemy_data, positions)
	loaded_enemies.emit(enemies)


func loadEntities(entity_data, positions):
	var entities = []

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


func _process(_delta):
	pass
