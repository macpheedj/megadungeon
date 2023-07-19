extends Node


func _ready():
	randomize()


func _process(_delta):
	pass


func _on_combatants_loaded_combatants():
	for combatant in $Combatants.combatants:
		$Map.add_child.call_deferred(combatant)
	
	# $Combatants.beginInitiative()

