extends CenterContainer
class_name FailedAppModal

@onready var main_lbl: RichTextLabel = %MainLbl

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
	main_lbl.text = "[center]You have failed %s. This is [shake][color=light_coral]UNACCEPTABLE[/color][/shake].[/center]
[center]
The following penalties have been applied. 
This is your reminder that you [shake]CANNOT[/shake] let any of these reach 0.
[/center]" % AppManager.current.display_name
	h_lbl.text = str(int(dHSLA.x))
	s_lbl.text = str(int(dHSLA.y))
	l_lbl.text = str(int(dHSLA.z))
	a_lbl.text = str(int(dHSLA.w))
	
	h_bar.trailing_value = new_HSLA.x - dHSLA.x
	s_bar.trailing_value = new_HSLA.y - dHSLA.y
	l_bar.trailing_value = new_HSLA.z - dHSLA.z
	a_bar.trailing_value = new_HSLA.w - dHSLA.w
	
	h_bar.value = new_HSLA.x
	s_bar.value = new_HSLA.y
	l_bar.value = new_HSLA.z
	a_bar.value = new_HSLA.w
	
	release_focus()
	grab_focus()
	grab_click_focus()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and event.is_pressed():
		Sections.start()
		queue_free()
