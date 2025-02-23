extends App

@onready var start_view: CenterContainer = $Start
@onready var main_view: Control = $Main
@onready var label: Label = $Main/Label
@onready var success_view: CenterContainer = $SuccessDisplay
@onready var rects: Control = $Main/Rects

@onready var timer: Timer = $Timer

@export var ShrinkingBtnScene: PackedScene

var total: int = 30
var count: int = 30
var initial: int = 1
var clicked: int = 0

const good_luck_thresh: float = 60.0
const good_luck_total: float = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_view.show()
	main_view.hide()
	success_view.hide()
	
	update_lbl()

func start() -> void:
	if Sections.luck >= good_luck_thresh:
		total = good_luck_total
	count = total
	update_lbl()
	start_view.hide()
	success_view.hide()
	main_view.show()
	for i in initial:
		spawn_rect()
	timer.start()

func _on_start_btn_pressed() -> void:
	start()

func update_lbl() -> void:
	label.text = "# Left: %d" % (total - clicked)

func _on_timer_timeout() -> void:
	spawn_rect()
	
	# Restart if more can be made
	if count > 0:
		timer.start()


func spawn_rect() -> void:
	if count <= 0:
		return
	
	count -= 1
	
	var b: ShrinkingBtn = ShrinkingBtnScene.instantiate()
	b.fail.connect(_on_fail)
	b.clicked.connect(_on_clicked)
	rects.add_child(b)
	
	# Randomize position
	var rect: Rect2 = get_rect()
	b.position = Vector2(
		randf_range(0, rect.size.x - b.size.x),
		randf_range(0, rect.size.y - b.size.y)
	)

func _on_fail() -> void:
	timer.stop()
	# Clear rects
	for child in rects.get_children():
		child.queue_free()
	AppManager.fail()
	AppManager.close_app()

func _on_clicked(btn: ShrinkingBtn) -> void:
	btn.queue_free()
	clicked += 1
	update_lbl()
	
	spawn_rect()
	
	if clicked == total:
		main_view.hide()
		success_view.show()
		AppManager.success()
