extends Node2D
class_name Dot

@onready var hitbox: Hitbox = $Hitbox


func _ready() -> void:
	hitbox.hit.connect(_on_hitbox_hit)


func _on_hitbox_hit() -> void:
	queue_free()
