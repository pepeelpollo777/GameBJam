class_name Fire
extends Area2D

@export var extinguishTimer: float = 0.7
@export var playerDamage: int = 10
@export var damageInterval: float = 1.0

var exposureTime: float = 0.0
var isExtinguished: bool = false
var activeGasAreas: Array = []
var overlappingPlayers: Array = []
var damageTimers: Dictionary = {}

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	monitoring = true
	
	if animated_sprite:
		animated_sprite.play("On")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("gas"):
		if not activeGasAreas.has(area):
			activeGasAreas.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("gas"):
		if activeGasAreas.has(area):
			activeGasAreas.erase(area)

func _physics_process(delta: float) -> void:
	if isExtinguished:
		return
	
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is Player and body.has_method("takeDamage"):
			body.takeDamage(playerDamage)
	
	
	var validGasCount = 0
	for area in activeGasAreas:
		if is_instance_valid(area) and area.monitorable:
			validGasCount += 1
		else:
			activeGasAreas.erase(area)
	
	if validGasCount > 0:
		exposureTime += delta
	else:
		exposureTime = max(0, exposureTime - delta * 0.5)
	
	if exposureTime >= extinguishTimer:
		extinguish()

func extinguish():
	isExtinguished = true
	monitoring = false
	
	if animated_sprite:
		animated_sprite.play("Off")
		
		await animated_sprite.animation_finished
	
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not overlappingPlayers.has(body):
			overlappingPlayers.append(body)
			damageTimers[body] = 0.0

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not overlappingPlayers.has(body):
			overlappingPlayers.erase(body)
		if damageTimers.has(body):
			damageTimers.erase(body)
