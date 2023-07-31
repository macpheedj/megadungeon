extends Area2D
class_name Encounter


signal triggered


func _on_area_entered(area: Character):
	print("area entered: " + area.CharacterType.keys()[area.character_type])
	if not area.character_type == area.CharacterType.Player:
		return
	
	triggered.emit(self)
