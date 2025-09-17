extends CharacterBody2D

@export var speed: float = 80.0

@onready var rayCastRight: RayCast2D = $WallRayRight
@onready var rayCastLeft: RayCast2D = $WallRayLeft


var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

	if rayCastRight.is_colliding():
		flipDirectionRight()
	elif rayCastLeft.is_colliding():
		flipDirectionLeft()

func flipDirectionRight() -> void:
	direction.x = -1
	flipSprite()

func flipDirectionLeft():
	direction.x = 1
	flipSprite()

func flipSprite():
	if $AnimatedSprite2D:
		$AnimatedSprite2D.flip_h = direction.x < 0
