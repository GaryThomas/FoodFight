extends "res://Scripts/Character.gd"

# Motion variables
const MAX_SPEED = 20
const UP = Vector3(0,1,0)
const ACCELERATION = 5
const DECELERATION = 10
const JUMP_SPEED = 15
const GRAVITY = -45

var velocity = Vector3()
var direction = Vector3()
var facing_direction = 0

# Animation variables
const BLEND_MINIMUM = 0.125
const RUN_BLEND_AMOUNT = 0.1
const IDLE_BLEND_AMOUNT = 0.25

var blend_state = 0

func _process(delta):
	move(delta)
	face_forward()
	animate()
	
func move(delta):
	var movement_direction = get_2d_movement()
	var camera_xform = $Camera.get_global_transform()
	direction = Vector3(0, 0, 0)
	direction += camera_xform.basis.z.normalized() * movement_direction.y	
	direction += camera_xform.basis.x.normalized() * movement_direction.x
	direction = move_vertically(direction, delta)
	velocity = horiz_acceleration(direction, delta)
	move_and_slide(velocity, UP)

func face_forward():
	$Armature.rotation.y = facing_direction
	
func get_2d_movement():
	var movement = Vector2()
	if Input.is_action_pressed("forward"):
		movement.y = -1
		facing_direction = 0
	if Input.is_action_pressed("back"):
		movement.y = 1
		facing_direction = PI
	if Input.is_action_pressed("left"):
		movement.x = -1
		facing_direction = PI * 0.5
	if Input.is_action_pressed("right"):
		movement.x = 1
		facing_direction = PI * 1.5
	return movement.normalized()
	
func move_vertically(direction, delta):
	velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_SPEED
	elif is_on_floor():
		velocity.y = 0
	direction.y = 0
	return direction.normalized()
		
func horiz_acceleration(direction, delta):
	var velocity_2D = velocity
	velocity_2D.y = 0
	var target = direction * MAX_SPEED
	var accel
	if direction.dot(velocity_2D) > 0:
		accel = ACCELERATION
	else:
		accel = DECELERATION
	velocity_2D = velocity_2D.linear_interpolate(target, accel * delta)
	velocity.x = velocity_2D.x
	velocity.z = velocity_2D.z
	return velocity
	
func _input(event):
	if Input.is_action_just_pressed("fire"):
		fire()
	
func animate():
	var animate = $Armature/AnimationTreePlayer
	if velocity.length() > BLEND_MINIMUM:
		blend_state += RUN_BLEND_AMOUNT
	else:
		blend_state -= IDLE_BLEND_AMOUNT
	blend_state = clamp(blend_state, 0, 1)
	animate.blend2_node_set_amount("IdleRun", blend_state)
