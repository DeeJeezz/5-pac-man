extends Node
class_name LevelController

@export var world_tilemap: TileMapLayer

var _walkable_map: Dictionary[Vector2i, bool] = { }


func _ready() -> void:
	_fill_walkable_map()
	_connect_signals()


func _connect_signals() -> void:
	EventBus.player_move_requested.connect(_on_player_move_requested)


func _on_player_move_requested(player_position: Vector2, direction: Vector2) -> void:
	var player_local_coords: Vector2i = world_tilemap.local_to_map(
		world_tilemap.to_local(player_position)
	)

	var tile_coords: Vector2i = player_local_coords
	while true:
		var next_tile_coords: Vector2i = tile_coords + Vector2i(direction)
		if next_tile_coords not in _walkable_map or not _walkable_map[next_tile_coords]:
			EventBus.player_allowed_to_move_to.emit(
				world_tilemap.to_global(world_tilemap.map_to_local(tile_coords))
			)
			return
		tile_coords = next_tile_coords


func _fill_walkable_map() -> void:
	for tile_coord: Vector2i in world_tilemap.get_used_cells():
		var tile_data: TileData = world_tilemap.get_cell_tile_data(tile_coord)
		_walkable_map[tile_coord] = tile_data.get_custom_data(Constants.WALKABLE_LAYER_NAME)

	_walkable_map.sort()
