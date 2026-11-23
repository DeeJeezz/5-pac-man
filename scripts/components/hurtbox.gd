extends Area2D
class_name Hurtbox

signal hit_done(target: Node2D)


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	hit_done.emit(area.owner)
