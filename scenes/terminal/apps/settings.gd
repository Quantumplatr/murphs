extends App


@onready var master_vol_slider: HSlider = %MasterVolSlider
@onready var music_vol_slider: HSlider = %MusicVolSlider
@onready var sfx_vol_slider: HSlider = %SfxVolSlider
@onready var ambient_vol_slider: HSlider = %AmbientVolSlider

func _ready() -> void:
	master_vol_slider.value = SettingsManager.settings.master_volume
	music_vol_slider.value = SettingsManager.settings.music_volume
	sfx_vol_slider.value = SettingsManager.settings.sfx_volume
	ambient_vol_slider.value = SettingsManager.settings.ambient_volume

func _on_master_vol_slider_drag_ended(value_changed: bool) -> void:
	SettingsManager.set_volume(SettingsManager.Volume.MASTER, master_vol_slider.value)

func _on_sfx_vol_slider_drag_ended(value_changed: bool) -> void:
	SettingsManager.set_volume(SettingsManager.Volume.SFX, sfx_vol_slider.value)

func _on_music_vol_slider_drag_ended(value_changed: bool) -> void:
	SettingsManager.set_volume(SettingsManager.Volume.MUSIC, music_vol_slider.value)

func _on_ambient_vol_slider_drag_ended(value_changed: bool) -> void:
	SettingsManager.set_volume(SettingsManager.Volume.AMBIENT, ambient_vol_slider.value)
