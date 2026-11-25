extends Node
class_name LevelController
## Controller for the level map, player movement.

@export var world_tilemap: TileMapLayer
@export var player: Player

var _walkable_map: Dictionary[Vector2i, bool] = { }

var _current_direction: Vector2i = Vector2i.ZERO
var _requested_direction: Vector2i = Vector2i.ZERO


func _ready() -> void:
	_fill_walkable_map()
	_connect_signals()

	#prints(
	#'Player position on tilemap',
	#player.position,
	#world_tilemap.local_to_map(world_tilemap.to_local(player.global_position)),
	#)


## Connecting all signals.
func _connect_signals() -> void:
	EventBus.player_move_requested.connect(_on_player_move_requested)


func _on_player_move_requested(direction: Vector2i) -> void:
	#prints(player.global_position, world_tilemap.local_to_map(player.global_position))
	var player_tilemap_coords: Vector2i = world_tilemap.local_to_map(player.global_position)
	prints('Player tilemap coords', player.global_position, player_tilemap_coords)
	var next_cell_coords: Vector2i = player_tilemap_coords + direction
	print(_walkable_map[next_cell_coords])
	if _walkable_map[next_cell_coords]:
		EventBus.player_allowed_to_move_to.emit(world_tilemap.to_global(world_tilemap.map_to_local(next_cell_coords)))
		prints(
			'player allowed to move to',
			next_cell_coords,
			world_tilemap.map_to_local(next_cell_coords),
			world_tilemap.to_global(world_tilemap.map_to_local(next_cell_coords)),
		)
		return


## Fill map with walkable and non-walkable fields on the map.
func _fill_walkable_map() -> void:
	for tile_coord: Vector2i in world_tilemap.get_used_cells():
		var tile_data: TileData = world_tilemap.get_cell_tile_data(tile_coord)
		_walkable_map[tile_coord] = tile_data.get_custom_data(Constants.WALKABLE_LAYER_NAME)

	_walkable_map.sort()
