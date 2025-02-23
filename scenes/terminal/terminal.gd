extends Control

@onready var main_win: MarginContainer = %MainWin
@onready var modals: Control = $Modals
@onready var super_modals: Control = $SuperModals
@onready var cryptic_lbl: RichTextLabel = %CrypticLbl

@export var initial_tasks: int = 5

@export var failed_modal: PackedScene
@export var game_over_modal: PackedScene
@export var task_info_modal: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cryptic_lbl.text = "[encrypted level=0]%s[/encrypted][encrypted level=1]%s[/encrypted]" % [
		Encryption.rot13("To be Forgiven of your Sins, you must "),
		Encryption.rot13("run the \"ritual\" Command   "),
	]
	
	modals.show()
	AppManager.started.connect(_start_app)
	AppManager.failed.connect(_fail_app)
	GameManager.game_failed.connect(_game_failed)
	TaskManager.task_highlighted.connect(_on_show_task)
	TaskManager.create_tasks(initial_tasks)
	_start_app(AppManager.current)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _start_app(app: AppData):
	for child in main_win.get_children():
		child.queue_free()
	
	var new_app: App = app.scene.instantiate()
	main_win.add_child(new_app)
	

func _fail_app(app: AppData, dHSLA: Vector4, new_HSLA: Vector4):
	var m: FailedAppModal = failed_modal.instantiate()
	m.dHSLA = dHSLA
	m.new_HSLA = new_HSLA
	modals.add_child(m)

func _game_failed():
	super_modals.show()
	var m: Control = game_over_modal.instantiate()
	#modals.add_child(m)
	super_modals.add_child(m)
	m.grab_focus()

func _on_show_task(task: TaskData) -> void:
	var m: TaskInfoModal = task_info_modal.instantiate()
	m.task = task
	modals.add_child(m)
