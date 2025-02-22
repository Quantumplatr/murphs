extends Resource
class_name Settings

@export var master_volume: float = 0.5:
	set(v):
		master_volume = clamp(v, 0, 1)
@export var sfx_volume: float = 0.5:
	set(v):
		sfx_volume = clamp(v, 0, 1)
@export var music_volume: float = 0.5:
	set(v):
		music_volume = clamp(v, 0, 1)
@export var ambient_volume: float = 0.5:
	set(v):
		ambient_volume = clamp(v, 0, 1)
