extends App

@onready var grid: GridContainer = %Grid
@onready var flagged_lbl: Label = %FlaggedLbl
@onready var cleared_lbl: Label = %ClearedLbl

@onready var success_display: VBoxContainer = %SuccessDisplay

@export var cols: int = 12
@export var rows: int = 6
@export var TOTAL_MINES: int = 8

var mines: int = 0
var flagged: int = 0:
	set(v):
		flagged = v
		update_flagged()
var cleared: int = 0:
	set(v):
		cleared = v
		update_cleared()

@export var CellScene: PackedScene

var cells: Array[Array] = []

func _ready() -> void:
	grid.show()
	success_display.hide()
	
	for child in grid.get_children():
		child.queue_free()
	
	# Generate cells
	grid.columns = cols
	for i in rows:
		var row: Array[Cell] = []
		for j in cols:
			var c: Cell = CellScene.instantiate()
			row.append(c)
			c.cell_pressed.connect(_on_pressed)
			c.cell_flagged.connect(_on_flagged)
			c.cell_unflagged.connect(_on_unflagged)
			grid.add_child(c)
		cells.append(row)
	
	update_cleared()
	update_flagged()
	
func _on_flagged(cell: Cell) -> void:
	flagged += 1

func _on_unflagged(cell: Cell) -> void:
	flagged -= 1

func _on_pressed(cell: Cell) -> void:
	open(cell)

func cell2rc(cell: Cell) -> Array[int]:
	var index = cell.get_index()
	var row: int = int(index / cols)
	var col: int = index % cols
	return [row,col]
func i2r(index: int) -> int:
	return int(index / cols)
func i2c(index: int) -> int:
	return index % cols
func rc2i(row: int, col: int) -> int:
	return row * cols + col


func open(cell: Cell) -> void:
	var rc := cell2rc(cell)
	var row := rc[0]
	var col := rc[1]
	
	if mines == 0:
		gen_mines(cell)
	
	cell.open()
	if not cell.is_mine:
		cleared += 1
	else:
		AppManager.fail()
	if cleared == rows * cols - TOTAL_MINES:
		success()
	
	# If 0, open neighbors
	if cell.num_neighbors == 0:
		for i in [row-1, row, row+1]:
			for j in [col-1, col, col+1]:
				# Check out of bounds
				if i < 0 or i >= rows:
					continue
				if j < 0 or j >= cols:
					continue
				
				var next: Cell = cells[i][j]
				
				if not next.is_open and not next.is_mine:
					open(next)

func get_num(row: int, col: int) -> int:
	var count := 0
	for i in [row-1, row, row+1]:
		for j in [col-1, col, col+1]:
			# Check out of bounds
			if i < 0 or i >= rows:
				continue
			if j < 0 or j >= cols:
				continue
				
			if cells[i][j].is_mine:
				count += 1
	return count

func gen_mines(avoid: Cell) -> void:
	# Generate mines
	while mines < TOTAL_MINES:
		var c: Cell = cells.pick_random().pick_random()
		# Don't place mine and first place clicked
		if c == avoid:
			continue
		
		if not c.is_mine:
			mines += 1
			c.is_mine = true
	
	# Calculate numbers (num neighboring mines)
	for i in rows:
		for j in cols:
			var c: Cell = cells[i][j]
			c.num_neighbors = get_num(i,j)

func update_cleared() -> void:
	if cleared_lbl:
		cleared_lbl.text = "%d/%d" % [cleared, rows * cols - TOTAL_MINES]

func update_flagged() -> void:
	if flagged_lbl:
		flagged_lbl.text = "%d/%d" % [flagged, TOTAL_MINES]

func success() -> void:
	grid.hide()
	success_display.show()
	AppManager.success()


func _on_close_btn_pressed() -> void:
	AppManager.close_app()
