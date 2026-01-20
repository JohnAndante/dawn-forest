extends ParallaxBackground
class_name Background

@export var can_process: bool
@export var layer_speed: Array[float]

func _ready():
	if can_process == false:
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	for index in get_child_count():
		if get_child(index) is ParallaxLayer:
			var child: ParallaxLayer = get_child(index)
			child.motion_offset.x -= delta * layer_speed[index]
			pass
