extends KinematicBody

# Constants are defined as accelerations (in m/s^2)
const ACCEL: float = 60.0
const FRICTION: float = 8.0

var velocity: Vector3
var angle: float

var nearby_objects: Array
var nearest_object: Spatial

onready var held_item: Spatial = $HeldItem
onready var model: Spatial = $Worker

onready var tween: Tween = $Tween
puppet var puppet_translation: Vector3 setget set_puppet_translation
puppet var puppet_velocity: Vector3
puppet var puppet_angle: float

func _ready() -> void:
	velocity = Vector3(0, 0, 0)
	nearby_objects = []

func set_puppet_translation(new_translation: Vector3) -> void:
	puppet_translation = new_translation
	tween.interpolate_property(self, "translation", translation, puppet_translation, 0.1)
	tween.start()

func _input(event: InputEvent) -> void:
	if is_network_master():
		if event.is_action_pressed("interact"):
			if held_item.get_child_count() == 0:
				if not nearest_object == null:
					if nearest_object.is_in_group("items"):
						nearest_object.pick_up(self.name)
					elif nearest_object.is_in_group("workstations"):
						nearest_object.pick_up(self.name)
					elif nearest_object.is_in_group("item_sources"):
						nearest_object.pick_up(self.name)
			else: # Already holding an item
				if not nearest_object == null:
					if nearest_object.is_in_group("workstations"):
						nearest_object.place(self)
					elif nearest_object.is_in_group("trash_cans"):
						nearest_object.place(self)
					elif nearest_object.is_in_group("finished_boxes"):
						nearest_object.place(self)
					else:
						held_item.get_child(0).put_down()
				else:
					held_item.get_child(0).put_down()

func _physics_process(delta: float) -> void:
	var target_angle = 0 # Will be used later to rotate player
	
	if is_network_master():
		$ActiveIndicator.visible = true
		
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
		$ActiveIndicator.visible = false
		
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
	
	# Lego-style wobble walking
	var speed = clamp(velocity.length() / 8.0, 0.0, 1.0)
	var offset = speed * 0.125 * sin(OS.get_ticks_msec()*0.02)
	model.rotation.z = offset
	model.rotation.x = speed * -0.125

# Tick rate of 0.03 seconds is approx. 30 FPS
# We don't need to send network updates at the full 60 FPS of _physics_process()
func _on_network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_translation", translation)
		rset_unreliable("puppet_velocity", velocity)
		rset_unreliable("puppet_angle", angle)

func _on_interaction_area_entered(area: Area) -> void:
	if is_network_master():
		# Assuming the area is always a direct child of the node we're interested in
		nearby_objects.append(area.get_parent())
		update_nearest()

func _on_interaction_area_exited(area: Area) -> void:
	if is_network_master():
		# Assuming the area is always a direct child of the node we're interested in
		if area.get_parent().has_method("glow_disable"):
			area.get_parent().glow_disable()
		
		if nearest_object == area.get_parent():
			nearest_object = null
		
		nearby_objects.erase(area.get_parent())
		if nearby_objects.size() > 0:
			update_nearest()

func update_nearest() -> void:
	var min_dist = 9999 # Large default
	
	for object in nearby_objects:
		var dist = (object.global_transform.origin - global_transform.origin).length()
		if dist < min_dist:
			nearest_object = object
			min_dist = dist
		
		# Disable glow on all items except nearest
		if object.has_method("glow_disable"):
			object.glow_disable()
	
	if nearest_object.has_method("glow_enable"):
		nearest_object.glow_enable()
