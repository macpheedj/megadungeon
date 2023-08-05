extends Area2D
class_name Reticle


const tile_size := 16


func show_rect(size: Vector2):
	$HitRect.shape.size = size * tile_size
	$HitRect.disabled = false
	$ColorRect.size = size * tile_size
	$ColorRect.position = $ColorRect.size / -2
	$ColorRect.visible = true
	$AnimationPlayer.play("blink")


func hide_rect():
	$HitRect.disabled = true
	$ColorRect.visible = false
	$AnimationPlayer.stop("blink")
