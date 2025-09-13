extends CharacterBody2D
class_name Player

@export var gravity: float = 0.5
@export var speed: int = 25
@export var acceleration: int = 230
@export var friction: int = 220
@export var jumpForce: int = -105
@export var airAcceleration: int = 300
@export var airFriction: int = 50

func _physics_process(delta: float) -> void:
	var inputAxis = Input.get_axis("left", "right")
	applyGravity(delta)
	handleAcceleration(inputAxis, delta) 
	applyFricction(inputAxis, delta) 
	handleJump(delta)
	handleAirAcceleration(inputAxis, delta) 
	applyAirFriction(inputAxis, delta) 
	move_and_slide()



func applyGravity(delta):
	if !is_on_floor():
		velocity += get_gravity() * gravity * delta

func handleAcceleration(inputAxis, delta):
	if !is_on_floor(): return
	if inputAxis != 0:
		velocity.x = move_toward(velocity.x,speed * inputAxis, acceleration * delta)

func applyFricction(inputAxis, delta):
	if inputAxis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handleJump(delta):
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = jumpForce
	elif !is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < jumpForce / 2:
			velocity.y = jumpForce / 2

func handleAirAcceleration(inputAxis, delta):
	if is_on_floor(): return
	if inputAxis != 0:
		velocity.x = move_toward(velocity.x, speed * inputAxis, airAcceleration * delta)

func applyAirFriction(inputAxis, delta):
	if inputAxis == 0 and !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, airFriction * delta)
