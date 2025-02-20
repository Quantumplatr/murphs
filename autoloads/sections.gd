extends Node

var hallucination: float = 90:
	set(value):
		hallucination = clamp(value, 0, 100)
var sleepiness: float = 95:
	set(value):
		sleepiness = clamp(value, 0, 100)
var luck: float = 60:
	set(value):
		luck = clamp(value, 0, 100)
var anger: float = 80:
	set(value):
		anger = clamp(value, 0, 100)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hallucination += delta * dh()
	sleepiness += delta * ds()
	luck += delta * dl()
	anger += delta * da()

func dh() -> float:
	return -0.4

func ds() -> float:
	return -0.5

func dl() -> float:
	return -0.2

func da() -> float:
	return -0.3
	
