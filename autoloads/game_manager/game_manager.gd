extends Node

signal game_failed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func restart() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	TaskManager.clear_tasks()
	Sections.reset()
	AppManager.close_app()
	AudioManager.restart()
	Encryption.clear()
	get_tree().reload_current_scene()

func game_over() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	AudioManager.play_music(AudioManager.game_over_music)
	AudioManager.play_sfx(AudioManager.Sfx.GAME_OVER)
	TaskManager.stop_timer()
	game_failed.emit()

func quit() -> void:
	# TODO: save?
	get_tree().quit()
