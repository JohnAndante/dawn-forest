extends CharacterBody2D
class_name Player

@onready var player_sprite: AnimatedSprite2D = $AnimatedTexture

@export var speed: int

var direction: Vector2

func _physics_process(_delta: float) -> void:
	horizontal_movement_env()
	move_and_slide()

func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_axis("left", "right")
	velocity.x = input_direction * speed
	print(velocity.x)
