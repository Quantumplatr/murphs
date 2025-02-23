extends Node

signal started(app: AppData)
signal failed(app: AppData, new_HSLA: Vector4, dHSLA: Vector4)
signal succeeded(app: AppData)

@export var none_app: AppData
@export var apps: Array[AppData] = []
@export var hidden_apps: Array[AppData] = []

@onready var current: AppData = none_app

enum AppError { OK, NOT_FOUND, MISSING_PROJECT}

func close_app() -> void:
	load_app(none_app)

func load_app(app: AppData, project: AppData.Project = AppData.Project.NONE) -> void:
	app.project = project
	current = app
	AudioManager.stop_music()
	if app.music:
		AudioManager.play_music(app.music)
	started.emit(app)

func try_load(command: String, dir: String, input: String = "") -> AppError:
	var app: AppData = null
	for a in AppManager.apps:
		if a.command == command:
			app = a
	for a in AppManager.hidden_apps:
		if a.command == command:
			app = a
	
	if not app:
		return AppError.NOT_FOUND
	
	var project: AppData.Project = AppData.Project.NONE
	if app.requires_project:
		project = get_project(dir, input)
		if project == AppData.Project.NONE:
			pass # TODO: implement missing project response
			return AppError.MISSING_PROJECT
		
	AppManager.load_app(app, project)
	
	return AppError.OK

func fail() -> void:
	AudioManager.play_sfx(AudioManager.Sfx.FAIL)
	var dHSLA := -Sections.HSLA / 2.0
	
	# Must lose at least 10 points
	# This is so if you're low, you don't drop from 10->5, you just lose
	dHSLA.x = min(dHSLA.x, -10)
	dHSLA.y = min(dHSLA.y, -10)
	dHSLA.z = min(dHSLA.z, -10)
	dHSLA.w = min(dHSLA.w, -10)
	
	var new_HSLA := Sections.delta(dHSLA)
	failed.emit(current, dHSLA, new_HSLA)

func get_project(dir: String, input: String) -> AppData.Project:
	var file_path := "%s/%s" % [dir,input]
	
	# TODO: maybe get this to work. exported files won't return get_path
	#       so idrk what to do in export. doing a workaround with just the input now
	#var file := FileAccess.open(file_path, FileAccess.READ)
	#
	#if not file:
		#return AppData.Project.NONE
	#
	#var tokens := file.get_path().split("/") # [..., Gamma.txt]
	#var file_name := tokens[len(tokens) - 1] # E.g. Gamma.txt
	#var project_name := file_name.split(".")[0] # E.g. Gamma
	
	var tokens := input.split("/") # [..., Gamma.txt]
	var file_name := tokens[len(tokens) - 1] # E.g. Gamma.txt
	var project_name := file_name.split(".")[0] # E.g. Gamma
	
	# Check projects to see if name matches
	for i in AppData.Project.size():
		var project := i as AppData.Project
		# Skip null
		if project == AppData.Project.NONE:
			continue
		# If right project file, return project
		if project_name == AppData.PROJECT_NAMES[project]:
			return project
	
	# Base case of null
	return AppData.Project.NONE

func success() -> void:
	AudioManager.play_sfx(AudioManager.Sfx.SUCCESS)
	succeeded.emit(current)
