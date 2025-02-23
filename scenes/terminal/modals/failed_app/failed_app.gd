extends CenterContainer
class_name FailedAppModal

@onready var main_lbl: RichTextLabel = %MainLbl



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_lbl.text = "[center]You have failed %s. This is [shake][color=light_coral]UNACCEPTABLE[/color][/shake].[/center]
[center]
The following penalties have been applied. 
This is your reminder that you [shake]CANNOT[/shake] let any of these reach 0.
[/center]" % AppManager.current.display_name
	
	release_focus()
	grab_focus()
	grab_click_focus()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and event.is_pressed():
		queue_free()
