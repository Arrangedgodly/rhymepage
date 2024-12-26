extends VBoxContainer

@export var api: Node

@onready var results_container: GridContainer = $Results

const RESULT = preload("res://scenes/result.tscn")

func _ready() -> void:
	api.rhymes_retrieved.connect(_set_results)
	api.sorted.connect(_set_results)

func _set_results(results: Array) -> void:
	for child in results_container.get_children():
		child.queue_free()
		
	for result in results:
		var result_scene = RESULT.instantiate()
		result_scene.init(result.word)
		results_container.add_child(result_scene)


func _on_sort_item_selected(index: int) -> void:
	var return_array
	match index:
		0:
			return_array = api.sort_rhymes("high_score")
		1:
			return_array = api.sort_rhymes("low_score")
		2:
			return_array = api.sort_rhymes("high_syllables")
		3:
			return_array = api.sort_rhymes("low_syllables")
	
	_set_results(return_array)
