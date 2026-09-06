class_name HitBox
extends Area2D

signal hit

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		var hurtbox=area
		hurtbox.hit.emit()
		hit.emit()
