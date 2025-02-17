extends VBoxContainer

@onready var display: RichTextLabel = %Display
@onready var input: LineEdit = %Input
@onready var prompt_lbl: RichTextLabel = %Prompt

const HOME = "res://drive"

var user: String = "0314"
var computer: String = "murphs"
var dir: DirAccess

var history: Array[String] = []
var history_index: int = -1

class Command:
	var function: Callable
	var help: String
	
	func _init(function: Callable, help: String):
		self.function = function
		self.help = help

var commands: Dictionary = {
	"cat": Command.new(cat, "Output file contents to console"),
	"cd": Command.new(cd, "Change directory"),
	"clear": Command.new(clear, "Clears the console"),
	"help": Command.new(help, "Displays available commands"),
	"history": Command.new(show_history, "Displays command history"),
	"ls": Command.new(ls, "Lists information about the files in the current directory"),
	"pwd": Command.new(pwd, "Output current directory to console"),
	"welcome": Command.new(welcome, "Display the welcome text seen upon startup"),
	"whoami": Command.new(whoami, "Shows the logged in user"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dir = DirAccess.open(HOME)
	update_prompt()
	display.append_text(welcome())

# Called every frame. 'delta' is the elapsed time since the previous frame. 
func _process(delta: float) -> void:
	pass

func _on_input_text_submitted(new_text: String) -> void:
	display.append_text(prompt()) # Prompt w/ formatting
	display.add_text(new_text + "\n") # User input w/ no formatting
	display.append_text(run(new_text)) # Result w/ formatting
	input.text = "" # Clear input

func _on_input_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		if len(history) > 0:
			if history_index == -1:
				history_index = len(history) - 1
			else:
				history_index = clamp(history_index - 1, 0, len(history) - 1)
			input.text = history[history_index]
	elif event.is_action_pressed("ui_down"):
		if len(history) > 0:
			if history_index != -1:
				history_index = clamp(history_index + 1, 0, len(history) - 1)
				input.text = history[history_index]

func update_prompt():
	prompt_lbl.clear()
	prompt_lbl.append_text(prompt())

func prompt() -> String:
	# 0314@murphs: ~$
	return "[color=medium_sea_green]%s@%s[/color]: [color=steel_blue]%s[/color]$ " % [user, computer, dir.get_current_dir().replace(HOME, "~")]

func run(input: String) -> String:
	var tokens := input.split(" ", false, 1)
	
	# If no command, skip
	if len(tokens) == 0:
		return ""
	
	var command_str := tokens[0]
	
	if command_str not in commands:
		return "command not found: %s\nTry [b]help[/b] to see available commands\n" % command_str
	
	history.push_back(input)
	history_index = -1 # Reset history navigation
	var command: Command = commands[command_str]
	var f = command.function
	return f.call(tokens[1]) if len(tokens) == 2 else f.call()


func sanitize_path(input: String) -> String:
	input = input.replace("://","I see you gamers trying to get other places. No.")
	input = input.replace("~", HOME)
	return input






func cat(input: String = "") -> String:
	input = sanitize_path(input)
	
	const usage := "Usage: cat [FILE]\n"
	if input == "":
		return "Usage: cat [FILE]\n"
	if not dir.file_exists(input):
		return "File not found\n%s" % usage
	
	# Try absolute path
	var file := FileAccess.open(input, FileAccess.READ) 
	if not file:
		# Try relative
		file = FileAccess.open("%s/%s" % [dir.get_current_dir(), input], FileAccess.READ)
	
	var content = file.get_as_text()
	return "%s\n" % content

func cd(input: String = "") -> String:
	if input != "":
		input = sanitize_path(input)
	else:
		input = HOME
	var res: Error = dir.change_dir(input)
	if res != OK:
		return "Invalid directory\n" + \
		"Usage: cd [DIRECTORY]\n" + \
		".. to go up a directory\n" + \
		"No directory or ~ to go home\n"
	# If bad path, go HOME
	if not dir.get_current_dir().begins_with(HOME):
		dir.change_dir(HOME)
	update_prompt()
	return ""

func clear() -> String:
	display.clear()
	return ""

func help() -> String:
	var str: String = "Available commands:\n"
	var keys: Array = commands.keys()
	keys.sort()
	for key in keys:
		var command: Command = commands[key]
		str += " - [color=pink]%s[/color]:\t%s\n" % [key, command.help]
	return str

func ls() -> String:
	var str: String = ""
	var directories = dir.get_directories()
	var files = dir.get_files()
	for directory in directories:
		if directory.begins_with("_"):
			directory = "[encrypted]%s[/encrypted]" % directory
		str += "[color=steel_blue]%s[/color]/ " % directory
	for file in files:
		if file.begins_with("_"):
			var file_parts = file.split(".")
			file = "[encrypted]%s[/encrypted].%s" % [file_parts[0], file_parts[1]]
		str += "[u]%s[/u] " % file
	return str + "\n"

func pwd() -> String:
	return "[color=steel_blue]%s[/color]\n" % dir.get_current_dir().replace(HOME, "~")

func show_history() -> String:
	return "\n".join(history) + "\n"

func welcome() -> String:
	return """Hello, employee [b]%s[/b]. Welcome to your first shift at [wave]Murph's[/wave].
Your job is vital to the survival of the company. [i]Nothing can go wrong[/i]. If any
of your stats drop to 0, well, let's just not let that happen.

To get started, type [b]help[/b] to learn your commands.
Read through [u]README.txt[/u] with the cat command to learn more.
""" % [user]

func whoami() -> String:
	return "%s\n" % user
