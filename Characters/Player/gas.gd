extends Area2D

@export var pushStrength: float = 360.0  
@export var beamOffsetX: float = 16.0    
@export var beamDurationSecs: float = 0.0 

var dir := Vector2.RIGHT
var enabled := false

func _ready():
	monitoring = false
	visible = false

func enableBeam(facingDir: int) -> void:
	enabled = true
	if facingDir < 0:
		dir = Vector2.LEFT
	else:
		dir = Vector2.RIGHT
	monitoring = true
	visible = true
	if facingDir < 0:
		position.x = beamOffsetX * -1
		scale.x = -1
	else:
		position.x = beamOffsetX
		scale.x = 1

func disableBeam() -> void:
	enabled = false
	monitoring = false
	visible = false

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	for body in get_overlapping_bodies():
		if body == get_parent():
			continue
		if body is CharacterBody2D:
			body.velocity += dir * pushStrength * delta
		elif body is RigidBody2D:
			body.applyImpulse(Vector2.ZERO, dir * pushStrength * delta)
