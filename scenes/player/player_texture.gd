extends Sprite2D
class_name PlayerTexture

signal game_over

@export var animation_path: AnimationPlayer
@export var player: CharacterBody2D
@export var attack_collision: CollisionShape2D

var suffix: String = "_right"
var normal_attack: bool = false
var shield_off: bool = false
var crouching_off: bool = false

func animate(direction: Vector2) -> void:
	verify_position(direction)
	update_ray_direction()
	
	if player.on_hit or player.dead:
		hit_behaviour()
	elif player.attacking or player.defending or player.crouching or player.is_next_to_wall():
		action_behaviour()
	elif direction.y != 0:
		vertical_behaviour(direction)
	elif player.landing == true:
		animation_path.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behaviour(direction)

func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
		suffix = "_right"
	elif direction.x < 0:
		flip_h = true
		suffix = "_left"

func update_ray_direction() -> void:
	if flip_h:
		player.wall_ray.target_position = Vector2(-8.0, 0)
		player.direction = 1
	else:
		player.wall_ray.target_position = Vector2(8.0, 0)
		player.direction = -1

func horizontal_behaviour(direction: Vector2) -> void:
	if direction.x != 0:
		animation_path.play("walk")
		pass
	else:
		animation_path.play("idle")
		pass

func vertical_behaviour(direction: Vector2) -> void:
	if direction.y > 0:
		animation_path.play("fall")
	elif direction.y < 0:
		animation_path.play("jump")

func hit_behaviour() -> void:
	player.set_physics_process(false)
	attack_collision.set_deferred("disabled", true)
	
	if player.dead:
		animation_path.play("death")
	elif player.on_hit:
		animation_path.play("hit")

func action_behaviour() -> void:
	if player.is_next_to_wall():
		animation_path.play("wall_slide")
	elif player.attacking and normal_attack:
		animation_path.play("attack" + suffix)
	if player.defending and shield_off:
		animation_path.play("defense")
		shield_off = false
	if player.crouching and crouching_off:
		animation_path.play("crouch")
		crouching_off = false

func update_collision_position() -> void:
	if player.is_next_to_wall():
		if flip_h and position != Vector2(-2, 0):
			position = Vector2(-2, 0)
		elif not flip_h and position != Vector2(1, 0):
			position = Vector2(1, 0)
	else:
		if position != Vector2.ZERO:
			position = Vector2.ZERO

func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"landing":
			player.landing = false
			player.set_physics_process(true)
		"attack_left":
			normal_attack = false
			player.attacking = false
		"attack_right":
			normal_attack = false
			player.attacking = false
		"hit":
			player.on_hit = false
			player.set_physics_process(true)
			if player.defending:
				animation_path.play("defense")
			if player.crouching:
				animation_path.play("crouch")
		"death": 
			emit_signal("game_over")
