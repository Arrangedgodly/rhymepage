extends VBoxContainer

@export var api: Node
@onready var results_container: HBoxContainer = $Results
const RESULT = preload("res://scenes/result.tscn")

func _ready() -> void:
	api.rhymes_retrieved.connect(_set_results)
	api.sorted.connect(_set_results)

func _set_results(results: Array) -> void:
	for result in results:
		var result_scene = RESULT.instantiate()
		result_scene.init(result.word)
		results_container.add_child(result_scene)
