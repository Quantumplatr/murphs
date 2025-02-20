extends Node

signal started(app: AppData)

@export var none_app: AppData
@export var apps: Array[AppData] = []

@onready var current: AppData = none_app

func load(app: AppData) -> void:
	current = app
	started.emit(app)

func try_load(command: String) -> bool:
	var app: AppData = null
	for a in AppManager.apps:
		if a.command == command:
			app = a
	if app:
		AppManager.load(app)
		return true
	else:
		return false
