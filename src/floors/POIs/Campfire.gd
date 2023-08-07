extends POI


var lit := false


func light_fire():
	if not lit:
		var frame = $Fire.get_frame()
		var progress = $Fire.get_frame_progress()
		$Fire.play("lit")
		$Fire.set_frame_and_progress(frame, progress)


func interact():
	light_fire()
