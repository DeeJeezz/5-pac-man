extends Node
class_name Main

@onready var current_scene: Node2D = %CurrentScene


func _ready() -> void:
	EventBus.scene_change_requested.connect(_change_current_scene)
	EventBus.quit_requested.connect(_on_quit_requested)

	_change_current_scene(Constants.GameScene.MAIN_MENU)


func _on_quit_requested() -> void:
	get_tree().quit()


func _clear_current_scene() -> void:
	for child in current_scene.get_children():
		child.queue_free()


func _change_current_scene(scene: Constants.GameScene) -> void:
	_clear_current_scene()
	var scene_path: String = Constants.SCENE_MAP[scene]
	var scene_instance: PackedScene = load(scene_path)
	current_scene.add_child(scene_instance.instantiate())
