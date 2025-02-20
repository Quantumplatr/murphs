extends HBoxContainer

@onready var hallucination: Bar = $Hallucination
@onready var sleepiness: Bar = $Sleepiness
@onready var luck: Bar = $Luck
@onready var anger: Bar = $Anger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO: switch to event
	hallucination.value = Sections.hallucination
	sleepiness.value = Sections.sleepiness
	luck.value = Sections.luck
	anger.value = Sections.anger
