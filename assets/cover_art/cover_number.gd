@tool
extends Control
class_name CoverNumber

@export var text: String:
	set(v):
		if label:
			label.text = v
	get:
		return label.text if label else ""

@onready var label: Label = $Label

func set_font_size(size: int) -> void:
	if label:
		label.add_theme_font_size_override("font_size", size)

func get_font_size() -> int:
	return label.get_theme_font_size("font_size")

var time: float = 0
var dist: float = 1

var direction := Vector2.UP

var MAX_DIST: float = 12.5
var SPEED: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = randf() * SPEED * 3.0
	dist = randf() * MAX_DIST
	direction = direction.rotated(randf() * 2 * PI)

func _process(delta: float) -> void:
	time += delta * SPEED
	update()
	
func update():
	if label:
		var dfs := get_font_size() - 80
		var dfs_offset: Vector2 = Vector2(-0.4,-1) * dfs
		label.position = direction * sin(time) * dist + dfs_offset
		
		var label_center: Vector2 = label.global_position
		var mouse_dist: float = (get_global_mouse_position() - label_center).length()
		
		
		#if mouse_dist < DETECT_MOUSE_DIST:
			#var t: float = SCALE_CURVE.sample(mouse_dist / DETECT_MOUSE_DIST)
			#var font_size: float = lerp(MIN_FONT_SIZE, MAX_FONT_SIZE, t)
			#label.add_theme_font_size_override("font_size", font_size)
		#else:
			#label.remove_theme_font_size_override("font_size")
