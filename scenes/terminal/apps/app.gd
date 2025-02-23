class_name App
extends Control

signal failed(app: App)

static var display_name: String = "App Name"


func _on_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta)) # open clicked link
