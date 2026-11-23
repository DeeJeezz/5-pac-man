extends CharacterBody2D
class_name Player

@export var speed: float = 1.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Hurtbox = $Hurtbox

var _target_position: Vector2
var allowed_to_move: bool = false


func _ready() -> void:
	hurtbox.hit_done.connect(_on_hurtbox_hit_done)
	EventBus.player_allowed_to_move_to.connect(_on_player_allowed_to_move_to)

	position = position.snapped(Vector2(Constants.CELL_SIZE, Constants.CELL_SIZE))


func _on_player_allowed_to_move_to(pos: Vector2) -> void:
	allowed_to_move = true
	_target_position = pos


func _on_hurtbox_hit_done(target: Node2D) -> void:
	prints('Hit', target)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed(&"move_left"):
			_move(Vector2.LEFT)
		elif event.is_action_pressed(&"move_right"):
			_move(Vector2.RIGHT)
		elif event.is_action_pressed(&"move_up"):
			_move(Vector2.UP)
		elif event.is_action_pressed(&"move_down"):
			_move(Vector2.DOWN)


func _rotate_sprite(direction: Vector2) -> void:
	animated_sprite.rotation = direction.angle()
	if direction == Vector2.LEFT:
		animated_sprite.flip_v = true
	else:
		animated_sprite.flip_v = false


func _move(direction: Vector2) -> void:
	EventBus.player_move_requested.emit(global_position, direction)
	_rotate_sprite(direction)


func _process(delta: float) -> void:
	if not _target_position:
		return

	if not allowed_to_move:
		return

	if position == _target_position:
		allowed_to_move = false
		return

	position = position.move_toward(_target_position, speed * 100 * delta)
