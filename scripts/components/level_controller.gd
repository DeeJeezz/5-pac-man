extends Node
class_name LevelController
## Controller for the level map, player movement.

@export var world_tilemap: TileMapLayer

var _walkable_map: Dictionary[Vector2i, bool] = { }


func _ready() -> void:
	_fill_walkable_map()
	_connect_signals()


## Connecting all signals.
func _connect_signals() -> void:
	EventBus.player_move_requested.connect(_on_player_move_requested)


## Processing [signal EventBus.player_move_requested]. Checks for the [member _walkable_map] and decide
## which position player allowed to move in desired direction.
func _on_player_move_requested(player_position: Vector2, direction: Vector2i) -> void:
	# Get player position on the tilemap.
	var player_local_coords: Vector2i = world_tilemap.local_to_map(world_tilemap.to_local(player_position))
	# Search for farthest cell on the tilemap player can go in desired direction.
	var tile_coords: Vector2i = player_local_coords
	while true:
		var next_tile_coords: Vector2i = tile_coords + direction
		# Player cannot go outside the tilemap and on non-walkable cells.
		if next_tile_coords not in _walkable_map or not _walkable_map[next_tile_coords]:
			EventBus.player_allowed_to_move_to.emit(world_tilemap.to_global(world_tilemap.map_to_local(tile_coords)))
			return
		tile_coords = next_tile_coords


## Fill map with walkable and non-walkable fields on the map.
func _fill_walkable_map() -> void:
	for tile_coord: Vector2i in world_tilemap.get_used_cells():
		var tile_data: TileData = world_tilemap.get_cell_tile_data(tile_coord)
		_walkable_map[tile_coord] = tile_data.get_custom_data(Constants.WALKABLE_LAYER_NAME)

	_walkable_map.sort()
