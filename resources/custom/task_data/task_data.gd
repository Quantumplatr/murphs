extends Resource
class_name TaskData

enum Status { TODO, FAILED, COMPLETE }

@export var app: AppData
@export var title: String = "Task Title"
@export var status: Status = Status.TODO
@export var project: AppData.Project
