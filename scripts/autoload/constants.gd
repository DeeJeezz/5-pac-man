extends Node

enum GameScene {
	GAME,
	MAIN_MENU,
}

const _GAME_SCENE_PATH: String = "res://scenes/test_game/test_game.tscn"
const _MAIN_MENU_SCENE_PATH: String = "res://scenes/main_menu/main_menu.tscn"

const SCENE_MAP: Dictionary = {
	GameScene.GAME: _GAME_SCENE_PATH,
	GameScene.MAIN_MENU: _MAIN_MENU_SCENE_PATH,
}

const CELL_SIZE: int = 16

const WALKABLE_LAYER_NAME: StringName = &"walkable"
