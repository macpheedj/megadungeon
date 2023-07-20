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
	setState(States.Initializing)


func _process(_delta):
	match state:
		States.Waiting:
			if Input.is_action_just_pressed("slam_space"):
				setState(States.EndingTurn)

		States.Initializing:
			$Combatants.setupCombatants()

		States.StartingRound:
			round_index += 1
			turn_index = 0
			setState(States.StartingTurn)

		States.StartingTurn:
			var actor = $Combatants.combatants[turn_index]
			actor.is_active = true
			print(actor.name)
			setState(States.Waiting)

		States.EndingTurn:
			turn_index += 1

			if $Combatants.isPlayerVictory():
				setState(States.Victory)
			elif $Combatants.isPlayerDefeat():
				setState(States.Defeat)
			elif turn_index < $Combatants.countLivingCombatants():
				setState(States.StartingTurn)
			else:
				setState(States.EndingRound)

		States.EndingRound:
			# TODO: resolve end-of-round effects?

			if $Combatants.isPlayerVictory():
				setState(States.Victory)
			elif $Combatants.isPlayerDefeat():
				setState(States.Defeat)
			else:
				setState(States.StartingRound)

		States.Victory:
			return

		States.Defeat:
			return


func setState(new_state: States):
	var code = "R" + str(round_index) + "T" + str(turn_index)
	var args = [code, States.keys()[state], States.keys()[new_state]]
	print("[%s] transitioning from '%s' to '%s'" % args)
	state = new_state


func _on_combatants_loaded_combatants():
	for combatant in $Combatants.combatants:
		$Map.add_child(combatant)
	
	setState(States.StartingRound)

