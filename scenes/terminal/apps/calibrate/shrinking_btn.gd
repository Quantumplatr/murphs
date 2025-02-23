extends Button
class_name ShrinkingBtn

signal fail
signal clicked(btn: ShrinkingBtn)

const start_size: Vector2 = Vector2(1,1) * 100

var speed: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = start_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var offset: Vector2 = Vector2(1,1) * delta * speed
	size -= offset
	position += offset / 2.0
	if size.x <= 0:
		fail.emit()
		queue_free()


func _on_pressed() -> void:
	clicked.emit(self)
