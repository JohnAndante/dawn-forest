extends Sprite2D
class_name PlayerTexture

@export var animation_path: AnimationPlayer
@export var player: CharacterBody2D

var suffix: String = "_right"
var normal_attack: bool = false
var shield_off: bool = false
var crouching_off: bool = false

func animate(direction: Vector2) -> void:
	verify_position(direction)

	if player.attacking or player.defending or player.crouching:
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

func horizontal_behaviour(direction: Vector2) -> void:
	if direction.x != 0:
		animation_path.play("walk")
		pass
	else:
		animation_path.play("idle")
		pass

func vertical_behaviour(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation_path.play("fall")
	elif direction.y < 0:
		animation_path.play("jump")

func action_behaviour() -> void:
	if player.attacking and normal_attack:
		animation_path.play("attack" + suffix)
	if player.defending and shield_off:
		animation_path.play("defense")
		shield_off = false
	if player.crouching and crouching_off:
		animation_path.play("crouch")
		crouching_off = false

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
