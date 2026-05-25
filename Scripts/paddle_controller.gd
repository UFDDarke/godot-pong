class_name PaddleController extends RigidBody2D

const PADDLE_SPEED : float = 250

var _lockedXCoordinate : float
var _maximumYCoordinate : float

# why does godot love magic strings
# TODO: find a way to assign from the inspector instead of using a magic string
@export var MoveUpInput : String
@export var MoveDownInput : String

var CurrentPaddleVelocity : Vector2

func _ready() -> void:
	_lockedXCoordinate = position.x
	_maximumYCoordinate = get_viewport().size.y


func _process(delta: float) -> void:
	_handlePaddleMovement(delta)


func _handlePaddleMovement(delta: float):
	var _verticalSpeed : float = PADDLE_SPEED * delta # how far to move the paddle vertically
	var _distanceToMove : Vector2 = Vector2(0, 0)

	# feels a little icky but these should cancel eachother out if both held which i like
	if(Input.is_action_pressed(MoveUpInput)):
		_distanceToMove -= Vector2(0, _verticalSpeed)

	if(Input.is_action_pressed(MoveDownInput)):
		_distanceToMove += Vector2(0, _verticalSpeed)

	CurrentPaddleVelocity = _distanceToMove

	# TODO: clamp the position of the paddle within screen bounds?


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = CurrentPaddleVelocity * PADDLE_SPEED
	position.x = _lockedXCoordinate
	position.y = clamp(position.y, 0, _maximumYCoordinate)