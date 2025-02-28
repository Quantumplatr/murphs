extends Node

var h0: float = 90
var s0: float = 95
var l0: float = 60
var a0: float = 80

var hallucination: float = h0:
	set(value):
		hallucination = clamp(value, 0, 100)
var sleepiness: float = s0:
	set(value):
		sleepiness = clamp(value, 0, 100)
var luck: float = l0:
	set(value):
		luck = clamp(value, 0, 100)
var anger: float = a0:
	set(value):
		anger = clamp(value, 0, 100)

var HSLA: Vector4:
	get:
		return Vector4(hallucination, sleepiness, luck, anger)
	set(v):
		hallucination = v.x
		sleepiness = v.y
		luck = v.z
		anger = v.w

var _running := false
var running := _running:
	get:
		return _running

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _running:
		hallucination += delta * dh()
		sleepiness += delta * ds()
		luck += delta * dl()
		anger += delta * da()
		check()

func dh() -> float:
	return -0.2

func ds() -> float:
	return -0.25

func dl() -> float:
	return -0.1

func da() -> float:
	return -0.15

func reset() -> void:
	_running = false
	hallucination = h0
	sleepiness = s0
	luck = l0
	anger = a0

func start() -> void:
	_running = true
func stop() -> void:
	_running = false

func delta(dHSLA: Vector4) -> Vector4:
	HSLA += dHSLA
	return HSLA

func check() -> void:
	if hallucination == 0 \
			or sleepiness == 0 \
			or luck == 0 \
			or anger == 0:
		GameManager.game_over()
		stop()
