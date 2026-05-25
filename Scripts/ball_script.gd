extends CharacterBody2D

# Constants
const INITIAL_SPEED : float = 400 # When a ball is launched, this is the value that CurrentSpeed is set to
const SPEED_PER_PADDLE_BOUNCE : int = 45
const MAX_Y_ANGLE : float = 0.7

# Inspector References

# Runtime Variables

var IsLaunched : bool = false
var LaunchDirection : LaunchDirections

var CurrentSpeed : float
var CurrentVelocity : Vector2

var _currentPaddleBounces : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# reset vars incase i am a fool
	IsLaunched = false


func _input(event: InputEvent) -> void:
	# At the start of the game, alows you to press spacebar to launch the ball when ready
	# Unused afterwards since the game loop should handle the ball launching automatically
	if (event.is_action_pressed("Ball Launch") && !IsLaunched):
			LaunchDirection = LaunchDirections.values().pick_random() # start it off with a random direction
			_launchBall()


func _launchBall():
	if(IsLaunched): return # don't do anything if it's already flying

	# We can now launch the ball, reset vars first
	IsLaunched = true
	CurrentSpeed = INITIAL_SPEED
	_currentPaddleBounces = 0

	# DEBUG to always send it left REMOVE ME LATER
	# TODO: on successive rounds, launches towards the player who was scored on
	LaunchDirection = LaunchDirections.LEFT

	var launchAngle : Vector2 = Vector2(0, 0)
	launchAngle.y = randf_range(-MAX_Y_ANGLE, MAX_Y_ANGLE)

	# Whichever launch drection we have, set the velocity in that direction
	match LaunchDirection:
		LaunchDirections.LEFT:
			launchAngle.x = -1

		LaunchDirections.RIGHT:
			launchAngle.x = 1

	_updateVelocity(launchAngle)



func _updateVelocity(targetDirection : Vector2):
	# Applies a baseline speed value, and increases speed per successive paddle bounce (maybe it should increase by percentage but im lazy)
	targetDirection = targetDirection.normalized()

	# Modify the targetDirection if it's too close to being completely vertical/horizontal (>0.7)
	targetDirection.y = clamp(targetDirection.y, -MAX_Y_ANGLE, MAX_Y_ANGLE)

	CurrentVelocity = targetDirection * (CurrentSpeed + (SPEED_PER_PADDLE_BOUNCE * _currentPaddleBounces))


func _physics_process(delta: float) -> void:
	if(!IsLaunched): return

	var collided = move_and_collide(CurrentVelocity * delta)


	if (collided):
		onCollision(collided)

	# otherwise just check to see if the ball is far enough to score a point
	var _whoScored : Player = _checkWhoScored()

	if (_whoScored != Player.NONE) :
		print(_whoScored)
		_resetBall()


func onCollision(collision: KinematicCollision2D) -> void:
	print("Collided!")

	var body = collision.get_collider()

	# Check if we just collided with a paddle or not
	if is_instance_of(body, PaddleController):
		# increase number of paddle bounces (speed gets faster with each bounce)
		_currentPaddleBounces += 1

	# Now, find the direction that the other collider is in, and bounce away from it
	var _bounceDirection = CurrentVelocity.bounce(collision.get_normal())
	print("Bounce Direction: ", _bounceDirection)
	_updateVelocity(_bounceDirection)


# returns NONE if ball within bounds
# otherwise, returns the player who gains a point, the winner
func _checkWhoScored() -> Player:

	if(position.x <= 0): return Player.RIGHT
	if(position.x > get_viewport().size.x): return Player.LEFT

	return Player.NONE


func _resetBall():
	var _startPosition = get_viewport().size as Vector2 / 2 # do i even need to cast it to a vector2 lol

	position = _startPosition

	IsLaunched = false




enum Player {NONE, LEFT, RIGHT}
enum LaunchDirections {LEFT, RIGHT}
