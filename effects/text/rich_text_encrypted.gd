@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextEncrypted
extends RichTextEffect


# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [encrypted param=2.0]hello[/encrypted] in text.
var bbcode := "encrypted"

const ENCRYPTION_CHARS = "!@#$%&!@#$%&0123456789"

# Reference: [BBCode in RichTextLabel — Godot Engine (stable) documentation in English](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#matrix)

# Gets TextServer for retrieving font information.
func get_text_server():
	return TextServerManager.get_primary_interface()

func _process_custom_fx(char_fx: CharFXTransform):
	var decrypted = false
	if decrypted:
		char_fx.color = Color.GREEN
		return true
	var speed = char_fx.env.get("speed", 10)
	var seed: int = floor(char_fx.elapsed_time * speed) # Get seed based on time
	var rand: int = int(hash(seed * (char_fx.relative_index + 1))) # Use relative index to get random
	var index: int = abs(rand % len(ENCRYPTION_CHARS)) # Turn into valid index
	char_fx.glyph_index = get_char(char_fx, index) # Get glyph_index for encryption char
	return true

func rand_char(char_fx: CharFXTransform) -> int:
	var index = randi() % len(ENCRYPTION_CHARS)
	return get_char(char_fx, index)

func get_char(char_fx: CharFXTransform, index: int) -> int:
	return get_text_server().font_get_glyph_index(char_fx.font, 1, ENCRYPTION_CHARS.unicode_at(index), 0)
