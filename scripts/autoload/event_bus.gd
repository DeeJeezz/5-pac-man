extends Node

## Signal sent when [Player] requested scene change, e.g. from main menu to game scene.
signal scene_change_requested(scene: Constants.GameScene)
## Signal sent when [Player] requested to quit game.
signal quit_requested

## Signal sent when [Player] requested to move.
## [param direction] is desired movement direction.
signal player_move_requested(direction: Vector2i)
## Signal sent when [LevelController] allowed [Player] to move in specific [param allowed_position].
signal player_allowed_to_move_to(allowed_position: Vector2)
