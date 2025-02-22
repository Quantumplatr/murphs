extends Node

signal started(app: AppData)
signal failed(app: AppData, new_HSLA: Vector4, dHSLA: Vector4)

@export var none_app: AppData
@export var apps: Array[AppData] = []

@onready var current: AppData = none_app

func close_app() -> void:
	load_app(none_app)

func load_app(app: AppData) -> void:
	current = app
	AudioManager.stop_music()
	if app.music:
		AudioManager.play_music(app.music)
	started.emit(app)

func try_load(command: String) -> bool:
	var app: AppData = null
	for a in AppManager.apps:
		if a.command == command:
			app = a
	if app:
		AppManager.load_app(app)
		return true
	else:
		return false

func fail() -> void:
	var dHSLA := -Sections.HSLA / 2.0
	
	# Must lose at least 10 points
	# This is so if you're low, you don't drop from 10->5, you just lose
	dHSLA.x = min(dHSLA.x, -10)
	dHSLA.y = min(dHSLA.y, -10)
	dHSLA.z = min(dHSLA.z, -10)
	dHSLA.w = min(dHSLA.w, -10)
	
	var new_HSLA := Sections.delta(dHSLA)
	failed.emit(current, dHSLA, new_HSLA)
