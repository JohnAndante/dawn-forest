extends Node
class_name Level

@onready var player: Player = $Player

func _ready() -> void:
	var _game_over: bool = player.player_sprite.game_over.connect(on_game_over)

func on_game_over() -> void:
	var _reload: bool = get_tree().reload_current_scene()
