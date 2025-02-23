extends HBoxContainer
class_name TaskLine

signal pressed(index: int)

@onready var button: Button = $Button
@onready var d_hsla: RichTextLabel = $dHSLA

var task: TaskData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if task:
		button.text = task.title
		d_hsla.clear()
		d_hsla.append_text(get_text())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_text() -> String:
	return "%s%s%s%s" % [
		get_sign_rep(task.dHSLA.x),
		get_sign_rep(task.dHSLA.y),
		get_sign_rep(task.dHSLA.z),
		get_sign_rep(task.dHSLA.w),
	]

func get_sign_rep(val: float) -> String:
	if val > 0:
		return "[color=sea_green]+[/color]"
	elif val < 0:
		return "[color=light_coral]-[/color]"
	else:
		return "[color=#fff4]0[/color]"
	


func _on_button_pressed() -> void:
	pressed.emit(get_index())
