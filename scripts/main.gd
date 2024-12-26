extends Control

@onready var body: TextEdit = $Grid/CenterMenu/Body
@onready var api: Node = $Api
@onready var rhymes: VBoxContainer = $Grid/LeftMenu/Rhymes
@onready var adjectives: VBoxContainer = $Grid/LeftMenu/Adjectives
@onready var sound_alikes: VBoxContainer = $Grid/LeftMenu/SoundAlikes
@onready var nouns: VBoxContainer = $Grid/LeftMenu/Nouns
@onready var words: VBoxContainer = $Grid/RightMenu/Words
@onready var synonyms: VBoxContainer = $Grid/RightMenu/Synonyms
@onready var antonyms: VBoxContainer = $Grid/RightMenu/Antonyms
@onready var freq_followers: VBoxContainer = $Grid/RightMenu/FreqFollowers

func _ready() -> void:
	body.new_last_word.connect(_on_body_new_last_word)
	rhymes.word_selected.connect(body.add_last_word)
	adjectives.word_selected.connect(body.add_last_word)
	
func _on_body_new_last_word(new_word: String) -> void:
	api.rhyme_request(new_word)
	api.adjective_request(new_word)
