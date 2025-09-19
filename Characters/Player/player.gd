extends CharacterBody2D
class_name Player

@export var gravity: float = 0.65
@export var speed: int = 45
@export var acceleration: int = 250
@export var friction: int = 240
@export var jumpForce: int = -150
@export var airAcceleration: int = 300
@export var airFriction: int = 150
@export var recoilForce: float = 260  
@export var maxRecoilSpeed: float = 325

@onready var gas: Area2D = $Gas
@onready var anims: AnimatedSprite2D = $AnimatedSprite2D


var isFire: bool = false

func _physics_process(delta: float) -> void:
	var inputAxis = Input.get_axis("left", "right")
	applyGravity(delta)
	handleAcceleration(inputAxis, delta) 
	applyFricction(inputAxis, delta) 
	handleJump(delta)
	handleAirAcceleration(inputAxis, delta) 
	applyAirFriction(inputAxis, delta) 
	handleFire(delta)
	move_and_slide()
	animCtrl()

func applyGravity(delta):
	if !is_on_floor():
		velocity += get_gravity() * gravity * delta

func handleAcceleration(inputAxis, delta):
	if !is_on_floor():
		return
	if inputAxis != 0:
		velocity.x = move_toward(velocity.x, speed * inputAxis, acceleration * delta)

func applyFricction(inputAxis, delta):
	if inputAxis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handleJump(delta):
	if is_on_floor():
		if Input.is_action_pressed("A"):
			velocity.y = jumpForce
	else:
		if Input.is_action_just_released("A") and velocity.y < jumpForce / 2:
			velocity.y = jumpForce / 2

func handleAirAcceleration(inputAxis, delta):
	if is_on_floor():
		return
	if inputAxis != 0:
		velocity.x = move_toward(velocity.x, speed * inputAxis, airAcceleration * delta)

func applyAirFriction(inputAxis, delta):
	if inputAxis == 0 and !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, airFriction * delta)

func animCtrl():
	if isFire:
		return
	if velocity.x == 0 and is_on_floor():
		anims.play("Idle")
	elif velocity.x > 0 and is_on_floor():
		anims.flip_h = false
		anims.play("Walk")
	elif velocity.x < 0 and is_on_floor():
		anims.flip_h = true
		anims.play("Walk")
	elif !is_on_floor():
		anims.play("Jump")

func handleFire(delta: float) -> void:
	var facingDir: int = 1
	if anims.flip_h:
		facingDir = -1
	else:
		facingDir = 1

	if Input.is_action_pressed("B"):
		isFire = true
		anims.play("Fire")
		velocity.x += -facingDir * recoilForce * delta
		velocity.x = clamp(velocity.x, -maxRecoilSpeed, maxRecoilSpeed)
		if gas != null:
			if gas.has_method("enableBeam"):
				gas.enableBeam(facingDir)
			else:
				gas.monitoring = true
				gas.visible = true
				gas.position.x = 16 * facingDir
				if facingDir < 0:
					gas.scale.x = -1
				else:
					gas.scale.x = 1
	else:
		if isFire:
			anims.play("Idle")
		isFire = false
		if gas != null:
			if gas.has_method("disableBeam"):
				gas.disableBeam()
