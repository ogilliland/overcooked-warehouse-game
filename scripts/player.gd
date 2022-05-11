extends KinematicBody

# Constants are defined as accelerations (in m/s^2)
const ACCEL: float = 60.0
const FRICTION: float = 8.0

var velocity: Vector3

func _ready() -> void:
	velocity = Vector3(0, 0, 0)

func _physics_process(delta: float) -> void:
	var direction := Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0,
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	
	velocity += direction * ACCEL * delta
	velocity -= velocity * FRICTION * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	# Rotate character to face input direction
	if direction.length() > 0.1:
		var target = Transform(
			Vector3(1, 0, 0),
			Vector3(0, 1, 0),
			Vector3(0, 0, 1),
			Vector3(0, 0, 0)
		)
		var angle = atan2(direction.x, direction.z)
		target = target.rotated(Vector3.UP, angle)
		
		# Convert basis to quaternion
		var a = Quat(transform.basis)
		var b = Quat(target.basis)
		# Interpolate using spherical-linear interpolation (SLERP)
		var c = a.slerp(b, 0.25)
		transform.basis = Basis(c)
