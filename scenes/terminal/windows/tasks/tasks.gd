extends ScrollContainer

@onready var list: ItemList = $ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TaskManager.task_added.connect(_on_task_added)
	TaskManager.task_failed.connect(_on_task_failed)
	TaskManager.task_completed.connect(_on_task_completed)
	TaskManager.cleared.connect(update_list)
	
	update_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	list.clear()
	for task: TaskData in TaskManager.todo:
		list.add_item(task.title)
