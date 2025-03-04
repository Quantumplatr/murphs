extends AppData
class_name RefinerAppData

@export var completed_digit: int = -1

func task_gen() -> TaskData:
	var t: RefinerTaskData = RefinerTaskData.new()
	t.app = self
	t.digit = randi() % 10
	t.project = rand_project()
	t.dHSLA = rand_dHSLA()
	t.title = task_gen_string % [t.digit, PROJECT_NAMES[t.project]]
	return t
