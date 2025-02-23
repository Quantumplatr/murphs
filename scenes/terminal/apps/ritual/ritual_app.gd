extends App

@onready var start_view: Control = $StartView
@onready var main: Control = $Main

@onready var block_timer: Timer = %BlockTimer
@onready var button_timer: Timer = %ButtonTimer
@onready var success_timer: Timer = $Main/SuccessTimer

@export var ShrinkingBtnScene: PackedScene
@export var BlockScene: PackedScene

@export var BUTTON_SPEED_UP: float = -0.01
@export var BLOCK_SPEED_UP: float = -0.01
@export var BLOCK_SIZE: float = 25.0
@export var BLOCK_CHANGE: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_view.show()
	main.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	start()

func start():
	main.show()
	start_view.hide()
	
	Sections.HSLA /= 2.0
	
	block_timer.start()
	button_timer.start()
	success_timer.start()



func _on_block_mouse_entered() -> void:
	fail()

func fail() -> void:
	match range(4).pick_random():
		0:
			Sections.hallucination = 0
		1:
			Sections.sleepiness = 0
		2:
			Sections.luck = 0
		3:
			Sections.anger = 0


func _on_button_timer_timeout() -> void:
	# Spawn
	var b: ShrinkingBtn = ShrinkingBtnScene.instantiate()
	b.z_index = -1
	b.fail.connect(fail)
	b.clicked.connect(_on_clicked)
	main.add_child(b)
	button_timer.wait_time += BUTTON_SPEED_UP
	button_timer.start()
	

func _on_clicked(btn: ShrinkingBtn) -> void:
	btn.queue_free()


func _on_success_timer_timeout() -> void:
	GameManager.game_win()


func _on_block_timer_timeout() -> void:
	var b: Block = BlockScene.instantiate()
	b.moving = true
	b.size = Vector2(1,1) * BLOCK_SIZE
	b.mouse_entered.connect(_on_block_mouse_entered)
	BLOCK_SIZE += BLOCK_CHANGE
	
	var rect: Rect2 = main.get_rect()
	var width := rect.size.x - b.size.x
	var height := rect.size.y - b.size.y
	
	# Pick random position
	match range(4).pick_random():
		# Top
		0:
			b.position = Vector2(
				randf_range(0, width),
				0
			)
		# Bottom
		1:
			b.position = Vector2(
				randf_range(0, width),
				height
			)
		# Left
		2:
			b.position = Vector2(
				0,
				randf_range(0, height)
			)
		# Right
		3:
			b.position = Vector2(
				width,
				randf_range(0, height)
			)
	
	
	main.add_child(b)
	block_timer.wait_time += BLOCK_SPEED_UP
	block_timer.start()
