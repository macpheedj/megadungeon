extends POI


enum { CLOSED, FULL, EMPTY }

var state := CLOSED


func open_chest():
	state = FULL
	$Sprite.play("open_full")
	# TODO: set off trap if trapped


func loot_chest():
	state = EMPTY
	$Sprite.play("open_empty")
	# TODO: add to inventory when inventory


func interact():
	match state:
		CLOSED:
			open_chest()

		FULL:
			loot_chest()

		EMPTY:
			return
