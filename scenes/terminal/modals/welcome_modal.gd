extends CenterContainer

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and event.is_pressed():
		Sections.start()
		TaskManager.start_timer()
		queue_free()
