extends Area2D

@export var pushStrength: float = 360.0  
@export var beamOffsetX: float = 16.0    
@export var beamDurationSecs: float = 0.0 

var dir := Vector2.RIGHT
var enabled := false
var overlapping_areas: Array = []

func _ready():
	monitoring = false
	visible = false
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
	if not overlapping_areas.has(area):
		overlapping_areas.append(area)

func _on_area_exited(area: Area2D):
	if overlapping_areas.has(area):
		overlapping_areas.erase(area)

func enableBeam(facingDir: int) -> void:
	enabled = true
	monitoring = true
	visible = true
	monitorable = true
	if facingDir < 0:
		dir = Vector2.LEFT
	else:
		dir = Vector2.RIGHT
	position.x = beamOffsetX * facingDir
	scale.x = -1 if facingDir < 0 else 1
	
	for area in overlapping_areas:
		if area.has_method("_on_area_entered"):
			area._on_area_entered(self)

func disableBeam() -> void:
	enabled = false
	monitoring = false
	visible = false
	monitorable = false

	for area in overlapping_areas:
		if area.has_method("_on_area_exited"):
			area._on_area_exited(self)

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	for body in get_overlapping_bodies():
		if body == get_parent():
			continue
		if body is CharacterBody2D:
			body.velocity += dir * pushStrength * delta
		elif body is RigidBody2D:
			body.apply_impulse(dir * pushStrength * delta)
