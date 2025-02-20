extends App

@export var NUMBER_SCENE: PackedScene

@export var cols: int = 21:
	set(v):
		cols = v
		list.columns = v
@export var rows: int = 6
@onready var list: GridContainer = $CenterContainer/List

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list.columns = cols
	for i in cols * rows:
		var new_lbl := NUMBER_SCENE.instantiate()
		#new_lbl.fit_content = true
		#new_lbl.autowrap_mode = TextServer.AUTOWRAP_OFF
		#new_lbl.append_text("[shake rate=10 level=10]%d[/shake]" % (randi() % 10))
		list.add_child(new_lbl)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
