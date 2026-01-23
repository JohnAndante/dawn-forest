extends CharacterBody2D
class_name Player

#@onready var player_sprite: PlayerTexture = $Texture
@export var player_sprite: PlayerTexture
@export var wall_ray: RayCast2D
@export var stats: Node

@export var speed: int
@export var jump_speed: int
@export var player_gravity: int

@export var wall_jump_speed: int
@export var wall_gravity: int
@export var wall_impulse_speed: int

var direction: int = 1
var jump_count: int = 0

var landing: bool = false
var on_wall: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false
var dead: bool = false
var on_hit: bool = false

var can_track_input: bool = false
var not_on_wall: bool = true
var was_on_floor: bool = false

func _physics_process(delta: float) -> void:
	horizontal_movement_env()
	vertical_movement_env()
	handle_wall_logic()
	actions_env()

	gravity(delta)
	move_and_slide()

	if is_on_floor() and not was_on_floor:
		landing = true

	was_on_floor = is_on_floor()
	player_sprite.animate(velocity)

func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_axis("left", "right")
	if not can_track_input or attacking:
		velocity.x = 0
		return

	velocity.x = input_direction * speed

func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall():
		jump_count = 0

	var can_jump = jump_count < 2 and can_track_input and not attacking
	if Input.is_action_just_pressed("jump") and can_jump:
		jump_count += 1
		if is_next_to_wall():
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direction
		else:
			velocity.y = jump_speed

func gravity(delta: float) -> void:
	if is_next_to_wall():
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity
	else:
		velocity.y += delta * player_gravity
		if velocity.y >= player_gravity:
			velocity.y = player_gravity

func handle_wall_logic() -> void:
	if is_next_to_wall():
		if not_on_wall:
			velocity.y = 0
			not_on_wall = false
	else:
		not_on_wall = true

func is_next_to_wall() -> bool:
	return wall_ray.is_colliding() and not is_on_floor()

func actions_env() -> void:
	attack()
	crouch()
	defense()

func attack() -> void:
	var can_attack: bool = not attacking and not crouching and not defending
	if Input.is_action_just_pressed("attack") and can_attack and is_on_floor():
		attacking = true
		player_sprite.normal_attack = true

func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		stats.shielding = false
		defending = false
		can_track_input = false
	elif not defending:
		crouching = false
		can_track_input = true
		stats.shielding = false
		player_sprite.crouching_off = true

func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		stats.shielding = true
		can_track_input = false
	elif not crouching:
		defending = false
		stats.shielding = false
		can_track_input = true
		player_sprite.shield_off = true
