extends Control

@onready var main_win: MarginContainer = %MainWin
@onready var modals: Control = $Modals
@onready var super_modals: Control = $SuperModals

@export var initial_tasks: int = 5

@export var failed_modal: PackedScene
@export var game_over_modal: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modals.show()
	AppManager.started.connect(_start_app)
	AppManager.failed.connect(_fail_app)
	GameManager.game_failed.connect(_game_failed)
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
