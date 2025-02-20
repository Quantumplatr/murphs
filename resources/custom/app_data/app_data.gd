extends Resource
class_name AppData

enum Project {
	DELTA = 0,
	EPSILON = 1,
	GAMMA = 2,
	OMEGA = 3,
	TAU = 4,
}

var PROJECT_NAMES := {
	Project.DELTA: "Delta",
	Project.EPSILON: "Epsilon",
	Project.GAMMA: "Gamma",
	Project.OMEGA: "Omega",
	Project.TAU: "Tau",
}

enum TaskGenTypes { STRING, PROJECT, DIGIT }

@export var display_name: String = "App Name"
@export var command: String = "appName"
@export var description: String = "App description"
@export var scene: PackedScene
@export var task_gen_string: String = "App Task in %s"

@export var project: Project

func task_gen() -> TaskData:
	var t: TaskData = TaskData.new()
	t.app = self
	t.project = randi() % Project.size()
	t.title = task_gen_string % PROJECT_NAMES[t.project]
	return t
