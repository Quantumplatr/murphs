@tool
extends MarginContainer

@export var title: String = "Window":
	get:
		return title
	set(value):
		title = value
		text_width = default_font.get_string_size(title).x
		custom_minimum_size = Vector2(offset*6+text_width, offset*6)
		
@export var thickness: int = 2
@export var color: Color = Color.WHITE
@export var show_background: bool = false
@export var bg_color: Color = Color(0.038, 0.076, 0.086)
#@export var bg_color: Color = Constants.MAIN_BG_COLOR

@export var focus_color: Color = Color.WHITE

var focused := false

#@export var offset: int = 10
var offset: int = 10

var default_font: Font = ThemeDB.fallback_font
var default_font_size: int = ThemeDB.fallback_font_size
var text_width: int

var all_sub_nodes: Array[Control] = []

func _ready():
	text_width = default_font.get_string_size(title).x
	custom_minimum_size = Vector2(offset*6+text_width, offset*6)
	
	add_nodes(self)
	
	# Connect to 
	get_viewport().gui_focus_changed.connect(_on_focus_changed)

func add_nodes(node: Node):
	for child in node.get_children():
		if child is Control:
			all_sub_nodes.push_back(child)
		if child.get_child_count() > 0:
			add_nodes(child)

func _on_focus_changed(control: Control) -> void:
	focused = all_sub_nodes.has(control)
	# TODO: conditional redraw. only if focused changed
	queue_redraw()

func _draw():
	# Draw background
	if show_background:
		draw_rect(Rect2(Vector2.ZERO, size), bg_color)
	
	var width := size.x - offset * 2
	var height := size.y - offset * 2
	
	var tl = Vector2(offset,offset)
	var bl = Vector2(offset, size.y - offset)
	var br = Vector2(size.x - offset, size.y - offset)
	var tr = Vector2(size.x - offset, offset)
	
	var text_pos = tl + Vector2(offset * 2, 0)
	var text_padding = offset
	
	var border_color = color if not focused else focus_color
	
	# Draw border
	draw_line(tl, bl, border_color, thickness) # Left
	draw_line(bl, br, border_color, thickness) # Bottom
	draw_line(br, tr, border_color, thickness) # Right
	draw_line(tl, text_pos + Vector2(-text_padding,0), border_color, thickness) # Top left
	draw_line(tr, text_pos + Vector2(text_width + text_padding,0), border_color, thickness) # Top right
	
	draw_string(default_font, text_pos + Vector2(0, default_font_size * 0.4), title, HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size, border_color)
