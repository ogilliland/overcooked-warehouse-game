extends KinematicBody

# Constants are defined as accelerations (in m/s^2)
const ACCEL: float = 60.0
const FRICTION: float = 8.0

var velocity: Vector3
var angle: float

onready var tween = $Tween
puppet var puppet_translation: Vector3 setget set_puppet_translation
puppet var puppet_velocity: Vector3
puppet var puppet_angle: float

func _ready() -> void:
	velocity = Vector3(0, 0, 0)

func set_puppet_translation(new_translation: Vector3) -> void:
	puppet_translation = new_translation
	tween.interpolate_property(self, "translation", translation, puppet_translation, 0.1)
	tween.start()

func _physics_process(delta: float) -> void:
	var target_angle = 0 # Will be used later to rotate player
	
	if is_network_master():
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
			angle = atan2(direction.x, direction.z)
		
		target_angle = angle
		
	else:
		# Lag compensation - predict player movement based on last velocity
		if not tween.is_active():
			move_and_slide(puppet_velocity, Vector3.UP) # Deliberately not setting puppet_velocity to return value here
		
		target_angle = puppet_angle
	
	# Rotate player to face target_angle
	var target_transform = Transform(
		Vector3(1, 0, 0),
		Vector3(0, 1, 0),
		Vector3(0, 0, 1),
		Vector3(0, 0, 0)
	)
	target_transform = target_transform.rotated(Vector3.UP, target_angle)
	
	# Convert basis to quaternion
	var a = Quat(transform.basis)
	var b = Quat(target_transform.basis)
	# Interpolate using spherical-linear interpolation (SLERP)
	var c = a.slerp(b, 0.25)
	transform.basis = Basis(c)

# Tick rate of 0.03 seconds is approx. 30 FPS
# We don't need to send network updates at the full 60 FPS of _physics_process()
func _on_network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_translation", translation)
		rset_unreliable("puppet_velocity", velocity)
		rset_unreliable("puppet_angle", angle)
