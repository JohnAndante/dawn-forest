extends AnimatedSprite2D
class_name PlayerTexture

@export var animation_path: AnimationPlayer

func animate(direction: Vector2) -> void:
	verify_position(direction)
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
