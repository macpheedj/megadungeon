extends POI


func toggle_door():
    var door_parts = [$TopOpen, $TopClosed, $BottomOpen, $BottomClosed]

    for part in door_parts:
        part.visible = not part.visible
    
    $Collision.disabled = not $Collision.disabled


func interact():
    # TODO: check player inventory for key (if locked (once inventory exists))
    toggle_door()
