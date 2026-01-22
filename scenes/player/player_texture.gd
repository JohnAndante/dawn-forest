extends Sprite2D
class_name PlayerTexture

@export var animation_path: AnimationPlayer
@export var player: CharacterBody2D

func animate(direction: Vector2) -> void:
	verify_position(direction)

	if direction.y != 0:
		vertical_behaviour(direction)
	elif player.landing == true:
		animation_path.play("land")
		player.set_physics_process(false)
	else:
		horizontal_behaviour(direction)

func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true

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

func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"land":
			player.landing = false
			player.set_physics_process(true)
