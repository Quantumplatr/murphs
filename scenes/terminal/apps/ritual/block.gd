extends Panel
class_name Block

var moving: bool = false
var direction: Vector2 = Vector2.ZERO
var speed: float = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = get_global_mouse_position() - (global_position + size / 2.0)
	direction = direction.normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moving:
		position += direction * speed * delta
		if not get_parent_control().get_rect().encloses(get_rect()):
			queue_free()
