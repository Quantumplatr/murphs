extends GridContainer
class_name dHSLADisplay


@onready var h_lbl: Label = %hLbl
@onready var s_lbl: Label = %sLbl
@onready var l_lbl: Label = %lLbl
@onready var a_lbl: Label = %aLbl
@onready var h_bar: Bar = %hBar
@onready var s_bar: Bar = %sBar
@onready var l_bar: Bar = %lBar
@onready var a_bar: Bar = %aBar


var dHSLA: Vector4
var new_HSLA: Vector4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()

func update():
	h_lbl.text = "%+d" % dHSLA.x
	s_lbl.text = "%+d" % dHSLA.y
	l_lbl.text = "%+d" % dHSLA.z
	a_lbl.text = "%+d" % dHSLA.w
	
	h_lbl.add_theme_color_override("font_color", color(dHSLA.x))
	s_lbl.add_theme_color_override("font_color", color(dHSLA.y))
	l_lbl.add_theme_color_override("font_color", color(dHSLA.z))
	a_lbl.add_theme_color_override("font_color", color(dHSLA.w))
	
	h_bar.trailing_value = new_HSLA.x - dHSLA.x
	s_bar.trailing_value = new_HSLA.y - dHSLA.y
	l_bar.trailing_value = new_HSLA.z - dHSLA.z
	a_bar.trailing_value = new_HSLA.w - dHSLA.w
	
	h_bar.value = new_HSLA.x
	s_bar.value = new_HSLA.y
	l_bar.value = new_HSLA.z
	a_bar.value = new_HSLA.w

func color(val: float) -> Color:
	if val > 0:
		return Constants.USER_COLOR
	elif val < 0:
		return Constants.ERROR_COLOR
	else:
		return Color(Color.WHITE, 0.5)
