extends Control

@onready var body: TextEdit = $Grid/CenterMenu/Body
@onready var api: Node = $Api

var menus = {}
var menu_types = [
	["LeftMenu", ["Rhymes", "Adjectives", "SoundAlikes", "Nouns"]],
	["RightMenu", ["Words", "Synonyms", "Antonyms", "FreqFollowers"]]
]

func _ready() -> void:
	_setup_menus()
	body.new_last_word.connect(_on_body_new_last_word)

func _setup_menus() -> void:
	for menu in menu_types:
		var menu_path = menu[0]
		for item in menu[1]:
			var node = get_node("Grid/" + menu_path + "/" + item)
			menus[item.to_lower()] = node
			node.word_selected.connect(body.add_last_word)

func _on_body_new_last_word(new_word: String) -> void:
	for menu_name in menus:
		menus[menu_name].request_word(new_word)
