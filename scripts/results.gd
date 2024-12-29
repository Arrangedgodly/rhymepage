extends VBoxContainer
signal word_selected(new_word: String)

@export var api: Node
@export var request_type: String = "rhyme"  # Default to rhyme, can be set in editor
@export var title_name: String = "Rhymes"

@onready var results_container: GridContainer = $ScrollContainer/Results
@onready var sort_option: OptionButton = $HBoxContainer/Sort
@onready var label: Label = $Label

const RESULT = preload("res://scenes/result.tscn")

func _ready() -> void:
	label.text = title_name
	
	var signal_name = request_type + "_retrieved"
	api.connect(signal_name, _set_results)
	
	_setup_sort_options()

func _setup_sort_options() -> void:
	sort_option.clear()
	sort_option.add_item("High Score")
	sort_option.add_item("Low Score")
	sort_option.add_item("High Syllables")
	sort_option.add_item("Low Syllables")

func _set_results(results: Array) -> void:
	for child in results_container.get_children():
		child.queue_free()
		
	for result in results:
		var result_scene = RESULT.instantiate()
		result_scene.init(result.word)
		result_scene.triggered.connect(_on_result_triggered)
		results_container.add_child(result_scene)

func _on_sort_item_selected(index: int) -> void:
	var method
	match index:
		0: method = api.SortMethod.HIGH_SCORE
		1: method = api.SortMethod.LOW_SCORE
		2: method = api.SortMethod.HIGH_SYLLABLES
		3: method = api.SortMethod.LOW_SYLLABLES
	
	var return_array = api.sort_results(request_type, method)
	_set_results(return_array)

func _on_result_triggered(new_word: String) -> void:
	word_selected.emit(new_word)

func request_word(word: String) -> void:
	var method_name = request_type + "_request"
	api.call(method_name, word)
