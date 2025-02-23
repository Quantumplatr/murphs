@tool
extends Node

enum Levels { BASIC, ADMIN, VULGAR }
const Passwords = {
	"BRKYZGMJM": Levels.BASIC,
	"n0thingC@nG0Wr0ng1": Levels.ADMIN,
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

func clear() -> void:
	for key in unlocked:
		unlocked[key] = false

func rot13(input: String) -> String:
	var output: String = ""
	var A = "A".unicode_at(0)
	var Z = "Z".unicode_at(0)
	var a = "a".unicode_at(0)
	var z = "z".unicode_at(0)
	
	for char in input:
		# Get unicode value
		var num := char.unicode_at(0)
		
		# Only move [a-zA-Z]
		if (a <= num and num <= z) or (A <= num and num <= Z):
			# Uppercase
			if char == char.to_upper():
				num = wrap(num + 13, A, Z + 1) # +1 b/c exclusive
			# Lowercase
			else:
				num = wrap(num + 13, a, z + 1) # +1 b/c exclusive
		output += char(num)
	return output
