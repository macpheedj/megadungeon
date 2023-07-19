extends Node


func _ready():
	pass


func _process(_delta):
	pass


func _on_combatants_loaded_enemies(loaded_enemies):
	for enemy in loaded_enemies:
		$Map.add_child.call_deferred(enemy)


func _on_combatants_loaded_players(loaded_players):
	for player in loaded_players:
		$Map.add_child.call_deferred(player)
