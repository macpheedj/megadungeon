extends Node


enum States {
	Waiting,
	Initializing,
	StartingRound,
	StartingTurn,
	EndingTurn,
	EndingRound,
	Victory,
	Defeat,
}


var state: States = States.Waiting
var round_index := 0
var turn_index := 0


func _ready():
	randomize()
	set_state(States.Initializing)


func _process(_delta):
	match state:
		# States.Waiting:
		# 	if Input.is_action_just_pressed("slam_space"):
		# 		set_state(States.EndingTurn)

		States.Initializing:
			$Combatants.setupCombatants()

		States.StartingRound:
			round_index += 1
			turn_index = 0
			set_state(States.StartingTurn)

		States.StartingTurn:
			var actor = $Combatants.combatants[turn_index]
			actor.set_state(actor.State.TakingTurn)
			set_state(States.Waiting)

		States.EndingTurn:
			turn_index += 1

			if $Combatants.isPlayerVictory():
				set_state(States.Victory)
			elif $Combatants.isPlayerDefeat():
				set_state(States.Defeat)
			elif turn_index < $Combatants.countLivingCombatants():
				set_state(States.StartingTurn)
			else:
				set_state(States.EndingRound)

		States.EndingRound:
			# TODO: resolve end-of-round effects?

			if $Combatants.isPlayerVictory():
				set_state(States.Victory)
			elif $Combatants.isPlayerDefeat():
				set_state(States.Defeat)
			else:
				set_state(States.StartingRound)

		States.Victory:
			return

		States.Defeat:
			return


func set_state(new_state: States):
	var code = "R" + str(round_index) + "T" + str(turn_index)
	var args = [code, States.keys()[state], States.keys()[new_state]]
	print("[%s] transitioning from '%s' to '%s'" % args)
	state = new_state


func _on_combatants_loaded_combatants():
	for combatant in $Combatants.combatants:
		combatant.turn_ended.connect(_on_combatant_turn_ended)
		$Map.add_child(combatant)
	
	set_state(States.StartingRound)


func _on_combatant_turn_ended():
	set_state(States.EndingTurn)
