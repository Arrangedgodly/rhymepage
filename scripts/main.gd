extends Control

@onready var body: TextEdit = $Grid/CenterMenu/Body
@onready var api: Node = $Api

func _ready() -> void:
	body.new_last_word.connect(_on_body_new_last_word)
	
func _on_body_new_last_word(new_word: String) -> void:
	api.rhyme_request(new_word)
