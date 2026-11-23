extends Node

signal scene_change_requested(scene: Constants.GameScene)
signal quit_requested

signal player_move_requested(player_position: Vector2, direction: Vector2)
signal player_allowed_to_move_to(position: Vector2)
