extends Area2D
class_name Hitbox

signal hit


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(_area: Area2D) -> void:
	hit.emit()
