extends Label

func _ready():
	update(AppManager.current)
	AppManager.started.connect(update)
	
func update(app: AppData):
	text = "App %s" % app.display_name.to_upper()
