extends TileMap
class_name Floor


func begin_encounter(encounter: Encounter):
	for player in $Party.get_children():
		player.set_state(player.State.StandingBy)
	
	for monster in encounter.get_node("Monsters").get_children():
		monster.set_state(monster.State.StandingBy)
		monster.visible = true


func _ready():
	for child in $Encounters.get_children():
		child.triggered.connect(_on_encounter_triggered)


func _on_encounter_triggered(_encounter: Encounter):
	print("encounter triggered!!!")
	begin_encounter(_encounter)
