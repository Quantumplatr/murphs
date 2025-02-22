extends Node

signal audio_changed

@export var default_settings: Settings
var settings: Settings

enum Volume {SFX, AMBIENT, MUSIC, MASTER }

const SETTINGS_FILE: String = "user://settings.tres"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check user:// for existing settings file
	var existing: Settings = ResourceLoader.load(SETTINGS_FILE)
	# If settings exist, use them
	if existing:
		settings = existing
	# If not, use default
	else:
		settings = default_settings.duplicate()
		save()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save() -> void:
	var error: Error = ResourceSaver.save(settings, SETTINGS_FILE)

func set_volume(type: Volume, value: float) -> void:
	match type:
		Volume.MASTER:
			settings.master_volume = value
		Volume.MUSIC:
			settings.music_volume = value
		Volume.SFX:
			settings.sfx_volume = value
		Volume.AMBIENT:
			settings.ambient_volume = value
	
	audio_changed.emit()
	save()
