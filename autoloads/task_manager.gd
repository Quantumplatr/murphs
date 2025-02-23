extends Node

signal task_added(task: TaskData)
signal task_failed(task: TaskData)
signal task_completed(task: TaskData)
signal task_highlighted(task: TaskData)
signal cleared()

@export var available_apps: Array[AppData] = []

@onready var timer: Timer = $Timer

var tasks: Array[TaskData] = []

var todo: Array[TaskData]:
	get:
		return tasks.filter(func(t): return t.status == TaskData.Status.TODO)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AppManager.succeeded.connect(_app_success)
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

func _app_success(app: AppData) -> void:
	for i in tasks.size():
		var task: TaskData = tasks[i]
		if task.app == app and task.project == app.project:
			
			# If refiner task, make sure digit is correct
			if task is RefinerTaskData:
				var completed_digit = (app as RefinerAppData).completed_digit
				if task.digit != completed_digit:
					continue
			
			tasks.remove_at(i)
			Sections.delta(task.dHSLA)
			task_completed.emit(task)
			break

func start_timer() -> void:
	timer.start()

func stop_timer() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	create_tasks(1)

func highlight_index(i: int) -> void:
	task_highlighted.emit(tasks[i])
