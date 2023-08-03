extends TileMap
class_name Floor


func _ready():
	randomize()

	for child in $Encounters.get_children():
		if child is Encounter:
			child.triggered.connect(_on_encounter_triggered)


func _on_encounter_triggered(_encounter: Encounter):
	print("encounter [%s] triggered!!!" % _encounter.name)

	$Encounters/AnimationPlayer.play(_encounter.name)
	$Combat.begin_combat(_encounter)
