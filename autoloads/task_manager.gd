extends Node

signal task_added(task: TaskData)
signal task_failed(task: TaskData)
signal task_completed(task: TaskData)
signal cleared()

@export var available_apps: Array[AppData] = []

var tasks: Array[TaskData] = []

var todo: Array[TaskData]:
	get:
		return tasks.filter(func(t): return t.status == TaskData.Status.TODO)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add(task: TaskData) -> void:
	tasks.push_back(task)
	task_added.emit(task)

func _rand_task() -> TaskData:
	var app: AppData = available_apps.pick_random()
	return app.task_gen()

func create_tasks(count: int) -> Array[TaskData]:
	var new_tasks: Array[TaskData] = []
	for i in count:
		var t = _rand_task()
		new_tasks.push_back(t)
		_add(t)
	return new_tasks

func clear_tasks() -> void:
	tasks.clear()
	cleared.emit()
