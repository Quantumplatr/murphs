extends Control

@export var TaskLineScene: PackedScene

@onready var list: VBoxContainer = %ItemList

@onready var timer_lbl: Label = %TimerLbl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TaskManager.task_added.connect(_on_task_added)
	TaskManager.task_failed.connect(_on_task_failed)
	TaskManager.task_completed.connect(_on_task_completed)
	TaskManager.cleared.connect(update_list)
	
	update_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not TaskManager.timer.is_stopped():
		timer_lbl.text = "New task in %ds" % TaskManager.timer.time_left

func _on_task_added(task: TaskData) -> void:
	print("Task Added: %s" % task)
	update_list()
	
func _on_task_failed(task: TaskData) -> void:
	print("Task Failed: %s" % task)
	update_list()
	
func _on_task_completed(task: TaskData) -> void:
	print("Task Completed: %s" % task)
	update_list()
	

func update_list() -> void:
	# clear
	for child in list.get_children():
		child.queue_free()
	# add tasks
	for task: TaskData in TaskManager.todo:
		var line: TaskLine = TaskLineScene.instantiate()
		line.task = task
		line.pressed.connect(_on_task_line_pressed)
		list.add_child(line)


func _on_item_list_item_selected(index: int) -> void:
	TaskManager.highlight_index(index)


func _on_task_line_pressed(index: int) -> void:
	TaskManager.highlight_index(index)
