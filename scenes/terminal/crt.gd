extends ColorRect

@export var h_curve: Curve
@export var s_curve: Curve
@export var l_curve: Curve
@export var a_curve: Curve

@export var h100: float = 0.003
@export var h0: float = 0.5

@export var s100: float = 0.4
@export var s0: float = 3.0

# TODO: luck

@export var a100: float = 0.05
@export var a0: float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update shader based on HSLA
	update_hallucination()
	update_sleepiness()
	update_luck()
	update_anger()

func update_hallucination():
	# Aberration
	var aberration = sample(h_curve, Sections.hallucination, h0, h100)
	material.set("shader_parameter/aberration", aberration)
	
func update_sleepiness():
	# Vignette Intensity
	var vi = sample(s_curve, Sections.sleepiness, s0, s100)
	material.set("shader_parameter/vignette_intensity", vi)
	
func update_luck():
	pass
	
func update_anger():
	# Grille Opacity
	var go = sample(a_curve, Sections.anger, a0, a100)
	material.set("shader_parameter/grille_opacity", go)

func sample(curve: Curve, value: float, v0: float, v100: float) -> float:
	var t = curve.sample(value / 100.0)
	return v0 + (v100 - v0) * t
