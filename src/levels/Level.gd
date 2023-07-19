extends Node


func _ready():
	pass


func _process(_delta):
	pass


func _on_combatants_loaded_combatants(loaded_players, loaded_enemies):
	for player in loaded_players:
		$Map.add_child.call_deferred(player)
	
	for enemy in loaded_enemies:
		$Map.add_child.call_deferred(enemy)
