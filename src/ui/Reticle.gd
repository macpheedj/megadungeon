extends Node2D
class_name Reticle


const tile_size := 16


func show_rect(size: Vector2):
	$Cursor/HitRect.shape.size = size * tile_size
	$Cursor/HitRect.disabled = false
	$Cursor/ColorRect.size = size * tile_size
	$Cursor/ColorRect.position = $Cursor/ColorRect.size / -2
	$Cursor/ColorRect.visible = true
	$Cursor/AnimationPlayer.play("blink")


func hide_rect():
	$Cursor/HitRect.disabled = true
	$Cursor/ColorRect.visible = false
	$Cursor/AnimationPlayer.stop("blink")
