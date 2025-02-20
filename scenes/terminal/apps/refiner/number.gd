extends Control

var value := -1

@onready var button: Button = $Button

var time: float = 0

var direction := Vector2.UP

@export var MAX_DIST: float = 5.0
@export var SPEED: float = 2.0
@export var SCALE_CURVE: Curve
@export var DETECT_MOUSE_DIST: float = 100.0
@export var MIN_FONT_SIZE: float = 16.0
@export var MAX_FONT_SIZE: float = 40.0

var dist: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = randi() % 10
	time = randf() * SPEED * 3.0
	dist = randf() * MAX_DIST
	direction = direction.rotated(randf() * 2 * PI)
	button.text = "%d" % value

func _process(delta: float) -> void:
	time += delta * SPEED
	update()

func update():
	button.position = direction * sin(time) * dist - button.size / 2.0
	
	var button_center: Vector2 = button.global_position + button.size / 2.0
	var mouse_dist: float = (get_global_mouse_position() - button_center).length()
	
	
	if mouse_dist < DETECT_MOUSE_DIST:
		var t: float = SCALE_CURVE.sample(mouse_dist / DETECT_MOUSE_DIST)
		var font_size: float = lerp(MIN_FONT_SIZE, MAX_FONT_SIZE, t)
		button.add_theme_font_size_override("font_size", font_size)
	else:
		button.remove_theme_font_size_override("font_size")


func _on_button_pressed() -> void:
	print("btn")
