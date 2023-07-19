extends Node

signal loaded_players
signal loaded_enemies


func _ready():
	loadPlayers()
	# establish initiative order
	# begin turns
	pass


func getSaveData():
	var file = FileAccess.open("res://tests/test_party.json", FileAccess.READ)
	var data = file.get_as_text()
	var json = JSON.new()
	json.parse(data)
	return json.get_data()


func loadPlayers():
	var players = []
	var positions = [
		Vector2(24, 24),
		Vector2(40, 24),
		Vector2(24, 40),
		Vector2(40, 40),
	]
	var save_data = getSaveData()

	for i in save_data.size():
		var player_data = save_data[i]
		var player = load(player_data.filename).instantiate()
		player.position = positions[i]

		for key in player_data.keys():
			if ["filename", "position_x", "position_y"].has(key):
				continue
			player.set(key, player_data[key])
		
		players.push_back(player)
	
	loaded_players.emit(players)


func _process(_delta):
	pass
