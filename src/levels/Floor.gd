extends TileMap
class_name floor


func _ready():
	for child in $Encounters.get_children():
		child.triggered.connect(_on_encounter_triggered)


func _on_encounter_triggered(_encounter: Encounter):
	print("encounter triggered!!!")
