@tool
extends Node

enum Levels { BASIC, ADMIN, VULGAR }
const Passwords = {
	"BRKYZGMJM": Levels.BASIC,
	"n0thingC@nG0Wr0ng!": Levels.ADMIN,
	"cuss": Levels.VULGAR,
}
const labels = {
	Levels.BASIC: "Basic",
	Levels.ADMIN: "Admin",
	Levels.VULGAR: "Vulgar",
}

var unlocked := {
	Levels.BASIC: false,
	Levels.ADMIN: false,
	Levels.VULGAR: false,
}

func unlock(input: String) -> String:
	# Check if correct
	if input not in Encryption.Passwords.keys():
		return "Invalid password.\nUsage: sudo [PASSWORD]\nExample: sudo good_password\n"
	
	# Get priviledge level
	var level: Levels = Passwords[input]
	var label: String = labels[level]
	
	# Check if already unlocked
	if unlocked[level]:
		return "[b]%s[/b] encryption is [i]already[/i] decrypted.\n" % [label]
	else:
		unlocked[level] = true
		return "[b]%s[/b] encryption has been decrypted.\n" % [label]
