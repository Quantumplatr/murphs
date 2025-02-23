extends Node

@export var fail_notif: AudioStream
@export var ping_notif: AudioStream
@export var success_notif: AudioStream
@export var game_over_notif: AudioStream

@export var game_over_music: AudioStream
@export var game_win_music: AudioStream

@onready var keypress_player: AudioStreamPlayer = %KeypressPlayer
@onready var click_player: AudioStreamPlayer = %ClickPlayer
@onready var notif_player: AudioStreamPlayer = %NotifPlayer

@onready var music_player: AudioStreamPlayer = %MusicPlayer

@onready var computer_hum_player: AudioStreamPlayer = %ComputerHumPlayer
@onready var danger_loop_player: AudioStreamPlayer = %DangerLoopPlayer

var master := AudioServer.get_bus_index("Master")
var music := AudioServer.get_bus_index("Music")
var sfx := AudioServer.get_bus_index("SFX")
var ambient := AudioServer.get_bus_index("Ambient")

var spooky := AudioServer.get_bus_index("Spooky")
var spooky_vol := 0.0
const SPOOKY_SPEED := 0.5

enum Sfx { KEYPRESS, CLICK, SUCCESS, FAIL, PING, GAME_OVER, GAME_WIN }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.audio_changed.connect(update_volumes)
	
	restart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Sections.running:
		update_spooky(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		play_sfx(Sfx.KEYPRESS)
	if event is InputEventMouseButton \
			and event.is_pressed() \
			and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
		play_sfx(Sfx.CLICK)

func restart():
	update_volumes()
	
	spooky_vol = 0.0
	computer_hum_player.play()
	danger_loop_player.stop()
	music_player.stop()

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

func stop_spooky() -> void:
	danger_loop_player.stop()
func update_spooky(delta: float) -> void:
	var min_HSLA: float = min(
		Sections.hallucination,
		Sections.sleepiness,
		Sections.luck,
		Sections.anger
	)
	# Ensure playing
	if not danger_loop_player.playing:
		danger_loop_player.play()
		
	# If min value of HSLA is < 50, apply spooky
	var start_spooky_at := 50.0
	
	# If min_HSLA > start_spooky_at, 0 volume
	var target: float = lerp(1, 0, min_HSLA / start_spooky_at)
	target = clamp(target, 0, 1)
	
	# Move volume towards target
	spooky_vol = lerp(spooky_vol, target, delta * SPOOKY_SPEED)
	
	# Apply volume
	AudioServer.set_bus_volume_db(spooky, linear_to_db(spooky_vol))

func play_sfx(sfx: Sfx) -> void:
	match sfx:
		Sfx.KEYPRESS:
			keypress_player.play()
		Sfx.CLICK:
			click_player.play()
		Sfx.PING:
			notif_player.stream = ping_notif
			notif_player.play()
		Sfx.FAIL:
			notif_player.stream = fail_notif
			notif_player.play()
		Sfx.SUCCESS:
			notif_player.stream = success_notif
			notif_player.play()
		Sfx.GAME_OVER:
			notif_player.stream = game_over_notif
			notif_player.play()

func play_music(stream: AudioStream) -> void:
	if not stream:
		return
	music_player.stream = stream
	music_player.play()

func stop_music() -> void:
	music_player.stop()
