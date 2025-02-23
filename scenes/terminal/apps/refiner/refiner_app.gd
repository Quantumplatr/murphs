extends App

@export var NUMBER_SCENE: PackedScene

@export var cols: int = 21:
	set(v):
		cols = v
		if list:
			list.columns = v
@export var rows: int = 6

@export var good_luck_thresh: float = 60.0
@export var good_luck_cols: int = 16
@export var good_luck_rows: int = 5

@onready var list: GridContainer = $Main/List

@onready var main_display: CenterContainer = $Main
@onready var success_display: CenterContainer = $SuccessDisplay

var numbers: Array[Number] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Apply luck
	if Sections.luck >= good_luck_thresh:
		cols = good_luck_cols
		rows = good_luck_rows
	
	success_display.hide()
	main_display.show()
	list.columns = cols
	for i in cols * rows:
		var n: Number = NUMBER_SCENE.instantiate()
		n.clicked.connect(_on_clicked)
		#new_lbl.fit_content = true
		#new_lbl.autowrap_mode = TextServer.AUTOWRAP_OFF
		#new_lbl.append_text("[shake rate=10 level=10]%d[/shake]" % (randi() % 10))
		list.add_child(n)
		numbers.append(n)
	

func _on_clicked(n: Number) -> void:
	var nums := get_valid_nums()
	
	if n.value not in nums:
		AppManager.fail()
	else:
		n.clear()
		check(nums)

func get_valid_nums() -> Array[int]:
	var nums: Array[int] = []
	
	# Go through tasks
	for task in TaskManager.tasks:
		# Filter to refiner tasks and relevant project
		if task is RefinerTaskData and task.project == AppManager.current.project:
			
			# Add digit to array
			var t := task as RefinerTaskData
			if t.digit not in nums:
				nums.append(t.digit)
	
	return nums

func check(against: Array[int]) -> void:
	
	# Count amount of numbers left
	# map[digit] = number left
	var map: Array[int] = []
	map.resize(10)
	map.fill(0)
	for n in numbers:
		if not n.cleared:
			map[n.value] += 1
	
	# Win condition
	for digit in against:
		if map[digit] == 0:
			success_display.show()
			main_display.hide()
			(AppManager.current as RefinerAppData).completed_digit = digit
			AppManager.success()
			break
