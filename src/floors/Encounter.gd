extends Area2D
class_name Encounter


signal triggered


var been_triggered := false


func _on_area_entered(area: Character):
	if not area.character_type == Character.CharacterType.Player:
		return
	
	if not been_triggered:
		been_triggered = true
		triggered.emit(self)
