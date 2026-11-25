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

var _direction_buffer_input: Vector2 = Vector2.ZERO


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


## Rotating [member Player.animated_sprite] accordingly it's movement direction.
func _rotate_sprite(direction: Vector2) -> void:
	animated_sprite.rotation = direction.angle()
	direction_arrow.rotation = direction.angle()
	if direction == Vector2.LEFT:
		animated_sprite.flip_v = true
	else:
		animated_sprite.flip_v = false


## Requesting movement in desired [param direction].
func _request_move(direction: Vector2) -> void:
	EventBus.player_move_requested.emit(Vector2i(direction))
	_rotate_sprite(direction)


func _process(delta: float) -> void:
	if not _target_position:
		return

	if not _allowed_to_move:
		return

	# If player reached target position - stop movement.
	if position == _target_position:
		_allowed_to_move = false
		return

	position = position.move_toward(_target_position, speed * delta)
