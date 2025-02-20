extends VBoxContainer
class_name Bar

@export var title: String = "I"

@onready var label: Label = $Label
@onready var progress: ProgressBar = $ProgressBar

var value: int = 50:
	set(v):
		value = v
		progress.value = v
	get:
		return value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = title


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
