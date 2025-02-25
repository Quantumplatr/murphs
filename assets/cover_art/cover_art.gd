extends Control

@onready var grid: GridContainer = %Grid
@onready var grid2: GridContainer = %Grid2

@export var CoverNumberScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i := 0
	
	# Try 1
	for child in grid.get_children():
		if child is Label:
			child = child as Label
			var text = child.text
			if int(text) != 0:
				var d := get_pi_digit(i)
				i += 1
				child.text = d
			else:
				child.add_theme_font_size_override("font_size", 120)
	
	# Try 2
	prep_grid2()

func get_pi_digit(index: int) -> String:
	const PI_STR := "031415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679"
	var digit := int(PI * pow(10, index)) % 10
	#print("%s: %s" % [index, digit])
	return PI_STR[index]

func prep_grid2():
	const cols = 11
	const rows = 5
	
	var ind := 0
	
	var murphs := "Murph's"
	for i in rows:
		for j in cols:
			var n: CoverNumber = CoverNumberScene.instantiate()
			grid2.add_child(n)
			var is_num: bool = i != 2 or j not in range(2,len(murphs)+2)
			if is_num:
				n.text = get_pi_digit(ind)
				ind += 1
			else:
				n.text = murphs[j-2]
				n.set_font_size(130)
