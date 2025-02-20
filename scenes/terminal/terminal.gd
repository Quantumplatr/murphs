extends Control

@onready var key_press_audio: AudioStreamPlayer = $KeyPressAudio

@onready var main_win: MarginContainer = %MainWin
@export var initial_tasks: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Modals.show()
	AppManager.started.connect(start_app)
	TaskManager.create_tasks(initial_tasks)
	start_app(AppManager.current)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		key_press_audio.play()

func start_app(app: AppData):
	for child in main_win.get_children():
		child.queue_free()
	
	var new_app: App = app.scene.instantiate()
	main_win.add_child(new_app)
	
