extends Node

@export var KEYPRESS_SOUND: AudioStream

@onready var keypress_player: AudioStreamPlayer = %KeypressPlayer
@onready var music_player: AudioStreamPlayer = %MusicPlayer

@onready var computer_hum_player: AudioStreamPlayer = %ComputerHumPlayer
@onready var danger_loop_player: AudioStreamPlayer = %DangerLoopPlayer

var master := AudioServer.get_bus_index("Master")
var music := AudioServer.get_bus_index("Music")
var sfx := AudioServer.get_bus_index("SFX")
var ambient := AudioServer.get_bus_index("Ambient")

enum Sfx { KEYPRESS }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.audio_changed.connect(update_volumes)
	update_volumes()
	
	computer_hum_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		play_sfx(Sfx.KEYPRESS)

func update_volumes():
	# Master volume
	var master_ind := AudioServer.get_bus_index("Master")
	var master_vol := linear_to_db(SettingsManager.settings.master_volume)
	AudioServer.set_bus_volume_db(master, master_vol)
	
	# Music Volume
	var music_ind := AudioServer.get_bus_index("Music")
	var music_vol := linear_to_db(SettingsManager.settings.music_volume * SettingsManager.settings.master_volume)
	AudioServer.set_bus_volume_db(music, music_vol)
	
	# SFX Volume
	var sfx_ind := AudioServer.get_bus_index("SFX")
	var sfx_vol := linear_to_db(SettingsManager.settings.sfx_volume * SettingsManager.settings.master_volume)
	AudioServer.set_bus_volume_db(sfx, sfx_vol)
	
	# Ambient Volume
	var ambient_ind := AudioServer.get_bus_index("Ambient")
	var ambient_vol := linear_to_db(SettingsManager.settings.ambient_volume * SettingsManager.settings.master_volume)
	AudioServer.set_bus_volume_db(ambient, ambient_vol)
	
func play_sfx(sfx: Sfx) -> void:
	match sfx:
		Sfx.KEYPRESS:
			keypress_player.play()

func play_music(stream: AudioStream) -> void:
	music_player.stream = stream
	music_player.play()

func stop_music() -> void:
	music_player.stop()
