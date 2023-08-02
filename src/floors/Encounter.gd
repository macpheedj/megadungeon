extends Area2D
class_name Encounter


signal triggered


func _on_area_entered(area: Character):
	if not area.character_type == area.CharacterType.Player:
		return
	
	triggered.emit(self)
