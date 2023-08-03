extends TileMap
class_name Floor


func _ready():
	randomize()

	for child in $Encounters.get_children():
		if child is Encounter:
			child.triggered.connect(_on_encounter_triggered)


func _on_encounter_triggered(_encounter: Encounter):
	print("encounter [%s] triggered!!!" % _encounter.name)

	$Combat.setup(_encounter)
	$Encounters/AnimationPlayer.play(_encounter.name)
	await $Encounters/AnimationPlayer.animation_finished
	$Combat.begin()
