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

var notes: Array[String] = []

var running: bool = false

# TODO: convert commands to resources? maybe?
class Command:
	var function: Callable
	var help: String
	
	func _init(function: Callable, help: String):
		self.function = function
		self.help = help

var commands: Dictionary = {
	"cd": Command.new(cd, "Change directory"),
	"clear": Command.new(clear, "Clears the console"),
	"help": Command.new(help, "Displays available commands"),
	"history": Command.new(show_history, "Displays command history"),
	"ls": Command.new(ls, "Lists information about the files in the current directory"),
	"note": Command.new(note, "Display existing notes or take a temporary note"),
	"pwd": Command.new(pwd, "Output current directory to console"),
	"quit": Command.new(quit, "Quit your job (close the game)"),
	"read": Command.new(read, "Output file contents to console"),
	"sudo": Command.new(sudo, "Decrypt encrypted secrets using a password"),
	"welcome": Command.new(welcome, "Display the welcome text seen upon startup"),
	"whoami": Command.new(whoami, "Shows the logged in user"),
}
var hidden_commands: Dictionary = {
	"dev_restart": Command.new(restart, "Restart the game"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dir = DirAccess.open(HOME)
	update_prompt()
	display.append_text(welcome())

func _on_input_text_submitted(new_text: String) -> void:
	# Don't run two at once
	if running:
		return
	running = true
	
	input.text = "" # Clear input
	display.append_text(prompt()) # Prompt w/ formatting
	display.add_text(new_text + "\n") # User input w/ no formatting
	
	# Result w/ formatting
	# One line at a time
	var output := run(new_text)
	var lines := output.split("\n")
	for i in len(lines):
		var line := lines[i]
		
		# If tree exists, delay between prints.
		# Tree won't exist when restarting
		var tree := get_tree()
		if tree:
			await tree.create_timer(Constants.PRINT_TIME).timeout
		
		display.append_text("%s" % line)
		# If not last line, add new line
		if i < len(lines) - 1:
			display.add_text("\n")
	
	# Done running
	running = false

func _on_display_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			input.grab_focus()
	
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
	input = input.strip_edges()
	
	# TODO: improve? maybe when commands are resources?
	if dir.file_exists(sanitize_path(input)):
		input = "read %s" % input
	
	var tokens := input.split(" ", false, 1)
	
	# If no command, skip
	if len(tokens) == 0:
		return ""
	
	var command_str := tokens[0]
	
	var app: AppData = null
	var app_exists := AppManager.try_load(command_str)
	if app_exists:
		history.push_back(input)
		history_index = -1 # Reset history navigation
		return ""
	
	if command_str not in commands and command_str not in hidden_commands:
		return "command not found: %s\nTry [color=purple]help[/color] to see available commands/apps\n" % command_str
	
	history.push_back(input)
	history_index = -1 # Reset history navigation
	var command: Command
	if command_str in commands:
		command = commands[command_str]
	else:
		command = hidden_commands[command_str]
	var f = command.function
	return f.call(tokens[1]) if len(tokens) == 2 else f.call()


func sanitize_path(input: String) -> String:
	input = input.replace("://","I see you gamers trying to get other places. No.")
	input = input.replace("~", HOME)
	return input







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

func clear(input: String = "") -> String:
	display.clear()
	return ""

func help(input: String = "") -> String:
	var str: String = "Available commands:\n"
	
	# Commands
	str += "[table=2]"
	var keys: Array = commands.keys()
	keys.sort()
	for key in keys:
		var command: Command = commands[key]
		str += "[cell] - [color=purple]%s[/color]:\t[/cell][cell]%s[/cell]" % [key, command.help]
	str += "[/table]"
	
	# Apps
	str += "Available apps:\n"
	str += "[table=2]"
	for app in AppManager.apps:
		str += "[cell] - [color=violet]%s[/color]:\t[/cell][cell]%s - %s[/cell]" % [app.command, app.display_name, app.description]
	str += "[/table]\n"
	
	return str

func ls(input: String = "") -> String:
	var str: String = ""
	var directories = dir.get_directories()
	var files = dir.get_files()
	for directory in directories:
		if directory.begins_with("_"):
			var level = Encryption.Levels.ADMIN if directory.begins_with("__") else Encryption.Levels.BASIC
			directory = "[encrypted level=%d]%s[/encrypted]" % [level, directory]
		str += "[color=steel_blue]%s[/color]/ " % directory
	for file in files:
		if file.begins_with("_"):
			var file_parts = file.split(".")
			var level = Encryption.Levels.ADMIN if file.begins_with("__") else Encryption.Levels.BASIC
			file = "[encrypted level=%d]%s[/encrypted].%s" % [level, file_parts[0], file_parts[1]]
		str += "[i]%s[/i] " % file
	return str + "\n"

func note(input: String = "") -> String:
	input = input.strip_edges()
	if input == "":
		if len(notes) == 0:
			return "No notes found.\nUsage: note [NOTE]\nIf no note is provided, lists existing notes.\n"
		else:
			var output = ""
			for n in notes:
				output += "- %s\n" % n
			return output
	notes.push_back(input)
	return ""

func pwd(input: String = "") -> String:
	return "[color=steel_blue]%s[/color]\n" % dir.get_current_dir().replace(HOME, "~")

func quit(input: String = "") -> String:
	# TODO: save?
	get_tree().quit()
	return ""

func read(input: String = "") -> String:
	input = sanitize_path(input)
	
	const usage := "Usage: read [FILE]\n"
	if input == "":
		return "Usage: read [FILE]\nExample: read ~/BASICS.txt\n"
	if not dir.file_exists(input):
		return "File not found\n%s" % usage
	
	# Try absolute path
	var file := FileAccess.open(input, FileAccess.READ) 
	if not file:
		# Try relative
		file = FileAccess.open("%s/%s" % [dir.get_current_dir(), input], FileAccess.READ)
	
	var content = file.get_as_text()
	return "%s\n" % content

func restart(input: String = "") -> String:
	TaskManager.clear_tasks()
	Sections.reset()
	get_tree().reload_current_scene()
	return ""

func sudo(input: String = "") -> String:
	input = input.strip_edges()
	return Encryption.unlock(input)

func show_history(input: String = "") -> String:
	return "\n".join(history) + "\n"

func welcome(input: String = "") -> String:
	return "Hello, employee [b]%s[/b]. Welcome to your first shift at [wave]Murph's[/wave]. Your job is vital to the survival of the company. [i]Nothing can go wrong[/i]. If any of your stats (HSLA in bottom-left) drop to 0, well, let's just say you won't want to find out what happens.\n\nTo get started, type [color=purple]help[/color] to learn your commands and read through [i]README.txt[/i] by typing [color=purple]read README.txt[/color].\n\nGood luck and thank you for being a part of the [wave]Murph[/wave] family :)\n" % [user]


func whoami(input: String = "") -> String:
	return "%s\n" % user
