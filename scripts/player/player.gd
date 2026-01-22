extends CharacterBody2D
class_name Player

#@onready var player_sprite: PlayerTexture = $Texture
@export var player_sprite: PlayerTexture

@export var speed: int
@export var jump_speed: int
@export var player_gravity: int

var direction: Vector2
var jump_count: int = 0

var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false

var can_track_input: bool = false

func _physics_process(delta: float) -> void:
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()
	
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

func actions_env() -> void:
	attack()
	crouch()
	defense()

func attack() -> void:
	var can_attack: bool = not attacking and not crouching and not defending
	if Input.is_action_just_pressed("attack") and can_attack and is_on_floor():
		attacking = true

func crouch() -> void:
	if Input.is_action_just_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		defending = false
		can_track_input = false
	elif not defending:
		crouching = false
		can_track_input = true

func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
	elif not crouching:
		defending = false
		can_track_input = true
