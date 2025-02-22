extends Resource
class_name AppData

enum Project {
	NONE = 0,
	DELTA = 1,
	EPSILON = 2,
	GAMMA = 3,
	OMEGA = 4,
	TAU = 5,
}

static var PROJECT_NAMES := {
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
@export var requires_project: bool = false

@export var music: AudioStream

func task_gen() -> TaskData:
	var t: TaskData = TaskData.new()
	t.app = self
	t.project = rand_project()
	t.title = task_gen_string % PROJECT_NAMES[t.project]
	t.dHSLA = rand_dHSLA()
	return t

func rand_project() -> Project:
	# Decrease size and add 1 to avoid value 0 which is null project
	return (randi() % (Project.size() - 1)) + 1

func rand_dHSLA() -> Vector4:
	const MIN := 10.0
	const MAX := 40.0
	const NEG_SCALE := -0.5
	var dHSLA: Vector4 = Vector4(
		randf_range(MIN,MAX),
		randf_range(MIN,MAX),
		randf_range(MIN,MAX),
		randf_range(MIN,MAX),
	)
	
	# Random set one to a negative
	match range(4).pick_random():
		0:
			dHSLA.x *= NEG_SCALE
		1:
			dHSLA.y *= NEG_SCALE
		2:
			dHSLA.z *= NEG_SCALE
		3:
			dHSLA.w *= NEG_SCALE
	
	
	# Random set one to a 0
	match range(4).pick_random():
		0:
			dHSLA.x = 0
		1:
			dHSLA.y = 0
		2:
			dHSLA.z = 0
		3:
			dHSLA.w = 0
	return dHSLA
