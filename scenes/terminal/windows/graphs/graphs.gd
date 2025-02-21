extends HBoxContainer

@onready var hallucination: Bar = $Hallucination
@onready var sleepiness: Bar = $Sleepiness
@onready var luck: Bar = $Luck
@onready var anger: Bar = $Anger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hallucination.value = Sections.hallucination
	sleepiness.value = Sections.sleepiness
	luck.value = Sections.luck
	anger.value = Sections.anger
	
	hallucination.trailing_value = Sections.hallucination
	sleepiness.trailing_value = Sections.sleepiness
	luck.trailing_value = Sections.luck
	anger.trailing_value = Sections.anger

var time: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > 1:
		time = 0
		# TODO: switch to event
	hallucination.value = Sections.hallucination
	sleepiness.value = Sections.sleepiness
	luck.value = Sections.luck
	anger.value = Sections.anger
