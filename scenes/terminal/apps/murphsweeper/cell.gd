extends Button
class_name Cell

signal cell_pressed(cell: Cell)
signal cell_flagged(cell: Cell)
signal cell_unflagged(cell: Cell)

var is_mine: bool = false
var num_neighbors: int = 0
var is_open: bool = false
var is_flagged: bool = false:
	set(v):
		is_flagged = v
		if is_flagged:
			cell_flagged.emit(self)
		else:
			cell_unflagged.emit(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_input(e: InputEventMouseButton) -> void:
	if e.pressed:
		match e.button_index:
			MOUSE_BUTTON_LEFT:
				if not is_flagged and not is_open:
					cell_pressed.emit(self)
			MOUSE_BUTTON_RIGHT:
				if not is_open:
					toggle_flag()

func open() -> void:
	is_open = true
	if is_flagged:
		toggle_flag()
	flat = true
	if is_mine:
		add_theme_color_override("font_color", Color.RED)
		text = "X"
	elif num_neighbors > 0:
		text = "%s" % num_neighbors
		var color: Color = [
			Color.WHITE, #0
			Color.STEEL_BLUE, #1
			Color.WEB_GREEN, #2
			Color.LIGHT_CORAL, #3
			Color.BLUE, #4
			Color.RED, #5
			Color.TEAL, #6
			Color.WHITE, #7
			Color.GRAY, #8
		][num_neighbors % 9]
		add_theme_color_override("font_color", color)

func toggle_flag() -> void:
	if not is_flagged:
		is_flagged = true
		text = "FL"
	else:
		is_flagged = false
		text = ""
