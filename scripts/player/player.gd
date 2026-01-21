extends CharacterBody2D
class_name Player

@onready var player_sprite: AnimatedSprite2D = $AnimatedTexture

@export var speed: int
@export var jump_speed: int
@export var player_gravity: int

var direction: Vector2
var jump_count: int = 0
var landing: bool = false


func _physics_process(delta: float) -> void:
	horizontal_movement_env()
	vertical_movement_env()
	
	gravity(delta)
	move_and_slide()
	player_sprite.animate(velocity)

func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_axis("left", "right")
	velocity.x = input_direction * speed

func vertical_movement_env() -> void:
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		jump_count += 1
		velocity.y = jump_speed

func gravity(delta: float) -> void:
	velocity.y += delta * player_gravity
	
	if velocity.y >= player_gravity:
		velocity.y = player_gravity
	pass
