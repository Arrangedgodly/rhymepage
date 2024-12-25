extends TextEdit
signal new_last_word(new_word: String)

var check_ready: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		check_ready = true

func _on_text_changed() -> void:
	if check_ready:
		check_ready = false
		if text.length() > 0:
			var last_word = get_last_word(text)
			if last_word != "":
				new_last_word.emit(last_word)

func get_last_word(input_text: String) -> String:
	# Split the text into words
	var words = input_text.strip_edges().split(" ", false)
	
	# Return empty string if no words
	if words.size() == 0:
		return ""
	
	# Return the last word
	return words[-1]
