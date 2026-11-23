extends CanvasLayer
class_name MainMenu

@onready var start_game_button: Button = %StartGameButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	start_game_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_start_button_pressed() -> void:
	EventBus.scene_change_requested.emit(Constants.GameScene.GAME)


func _on_quit_button_pressed() -> void:
	EventBus.quit_requested.emit()
