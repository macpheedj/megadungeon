extends Node


func _ready():
	pass


func _process(_delta):
	pass


func _on_combatants_loaded_enemies():
	pass


func _on_combatants_loaded_players(loaded_players):
	for player in loaded_players:
		$Map.add_child.call_deferred(player)
