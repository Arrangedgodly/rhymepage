extends Button
signal triggered(new_text: String)

func init(new_text: String) -> void:
	text = new_text
	tooltip_text = new_text

func _on_pressed() -> void:
	triggered.emit(text)
