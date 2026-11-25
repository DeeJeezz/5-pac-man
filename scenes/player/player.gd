extends CharacterBody2D
class_name Player

## Movement speed.
@export var speed: float = 15

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var direction_arrow: Sprite2D = %DirectionArrow
@onready var hurtbox: Hurtbox = $Hurtbox

## Position for [Player] to reach.
var _target_position: Vector2
## Flag shows if [Player] can move.
var _allowed_to_move: bool = false

var _requested_direction: Vector2i = Vector2i.ZERO


func _ready() -> void:
	_connect_signals()
	# Snap player's position to grid.
	position = position.snapped(Constants.GRID)


## Connecting all signals.
func _connect_signals() -> void:
	hurtbox.hit_done.connect(_on_hurtbox_hit_done)
	EventBus.player_allowed_to_move_to.connect(_on_player_allowed_to_move_to)


## Processing [signal EventBus.player_allowed_to_move_to].
## Sets up [member Player._allowed_to_move] and [member Player._target_position], so [Player]
## can start moving to [param allowed_position].
func _on_player_allowed_to_move_to(allowed_position: Vector2) -> void:
	_allowed_to_move = true
	_target_position = allowed_position


## Processing [signal Hurtbox.hit_done] signal.
func _on_hurtbox_hit_done(target: Node2D) -> void:
	prints('Hit', target)


## Catch player's input.
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed(&"move_left"):
			_request_move(Vector2.LEFT)
		elif event.is_action_pressed(&"move_right"):
			_request_move(Vector2.RIGHT)
		elif event.is_action_pressed(&"move_up"):
			_request_move(Vector2.UP)
		elif event.is_action_pressed(&"move_down"):
			_request_move(Vector2.DOWN)


func _request_move(direction: Vector2) -> void:
	if not _requested_direction:
		EventBus.player_move_requested.emit(direction)
	_requested_direction = direction


func _process(delta: float) -> void:
	if not _allowed_to_move:
		return

	position = position.move_toward(_target_position, speed * delta)
	if not _requested_direction:
		return

	if position == _target_position:
		EventBus.player_move_requested.emit(_requested_direction)
		print_debug('player requested another move')
