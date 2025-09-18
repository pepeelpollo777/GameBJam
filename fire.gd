class_name Fire
extends Area2D

@export var extinguishTimer: float = 0.7

var exposureTime: float = 0.0
var isExtinguished: bool = false
var activeGasAreas: Array = []  # Para rastrear áreas de gas activas manualmente

func _ready() -> void:
	monitoring = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("gas"):
		print("Gas detectado (entered)")
		if not activeGasAreas.has(area):
			activeGasAreas.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("gas"):
		print("Gas salió (exited)")
		if activeGasAreas.has(area):
			activeGasAreas.erase(area)

func _physics_process(delta: float) -> void:
	if isExtinguished:
		return
	
	# Filtrar solo las áreas de gas que están activas
	var validGasCount = 0
	for area in activeGasAreas:
		if is_instance_valid(area) and area.monitorable:
			validGasCount += 1
		else:
			# Remover áreas inválidas
			activeGasAreas.erase(area)
	
	print("Áreas de gas activas: ", validGasCount)
	
	if validGasCount > 0:
		exposureTime += delta
		print("Expuesto al gas: ", exposureTime)
	else:
		exposureTime = max(0, exposureTime - delta * 0.5)  # Reducir gradualmente
	
	if exposureTime >= extinguishTimer:
		extinguish()

func extinguish():
	isExtinguished = true
	monitoring = false
	print("Fuego apagado!")
	queue_free()
