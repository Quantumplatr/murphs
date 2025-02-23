extends CenterContainer
class_name TaskInfoModal

@onready var app_display: Label = %AppDisplay
@onready var project_display: Label = %ProjectDisplay
@onready var help_display: RichTextLabel = %HelpDisplay
@onready var d_hsla_display: dHSLADisplay = %dHSLADisplay
@onready var task_display: RichTextLabel = %TaskDisplay

@export var task: TaskData

func _ready():
	update()

func update():
	var project_name: String = AppData.PROJECT_NAMES[task.project]
	app_display.text = task.app.display_name
	project_display.text = project_name
	help_display.text = "[color=purple]%s %s[/color]" % [task.app.command, project_name]
	task_display.text = task.title
	
	d_hsla_display.dHSLA = task.dHSLA
	d_hsla_display.new_HSLA = Sections.HSLA + task.dHSLA
	d_hsla_display.update()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and event.is_pressed():
		queue_free()
