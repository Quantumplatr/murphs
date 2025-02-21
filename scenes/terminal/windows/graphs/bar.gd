extends VBoxContainer
class_name Bar

@export var title: String = "I"
@export var animate: bool = false
@export var ANIM_SPEED: float = 0.5

@onready var back_bar: ProgressBar = %BackBar
@onready var front_bar: ProgressBar = %FrontBar

@onready var label: Label = $Label

var value: float = 50:
	set(v):
		value = v
		update()

var trailing_value: float = 0:
	set(v):
		trailing_value = v
		update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = title


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animate:
		trailing_value = lerp(trailing_value, value, delta * ANIM_SPEED)
		update()

func update():
	# Increased, show green
	if value > trailing_value:
		back_bar.value = value
		front_bar.value = trailing_value
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = Constants.USER_COLOR
		back_bar.add_theme_stylebox_override("fill", style)
	# Decreased, show red
	else:
		front_bar.value = value
		back_bar.value = trailing_value
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = Color.MAROON
		back_bar.add_theme_stylebox_override("fill", style)
