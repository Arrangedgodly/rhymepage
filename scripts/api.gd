extends Node

signal rhymes_retrieved(results: Array)
signal sorted

const BASE_URL = "https://api.datamuse.com/words?"
const END_URL = "&v=enwiki&max=50"
@onready var rhyme: HTTPRequest = $Rhyme

var rhymes = []

func _ready():
	rhyme.request_completed.connect(_on_rhyme_request_completed)

func sort_field(array_name: String, method_name: String) -> Array:
	var active_array
	match array_name:
		"rhymes": active_array = rhymes
	
	var sort_method
	match method_name:
		"low_score":
			sort_method = _sort_by_low_score
		"high_score":
			sort_method = _sort_by_high_score
		"low_syllables":
			sort_method = _sort_by_low_syllables
		"high_syllables":
			sort_method = _sort_by_high_syllables
	
	active_array.sort_custom(sort_method)
	return active_array

func sort_rhymes(method_name: String) -> Array:
	return sort_field("rhymes", method_name)
	
func rhyme_request(word: String):
	rhyme.request(BASE_URL + "rel_rhy=" + word + END_URL)

func _on_rhyme_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	rhymes = json
	rhymes_retrieved.emit(rhymes)

func _sort_by_low_score(a, b) -> bool:
	if a.score < b.score:
		return true
	return false

func _sort_by_high_score(a, b) -> bool:
	if a.score > b.score:
		return true
	return false

func _sort_by_low_syllables(a, b) -> bool:
	if a.numSyllables < b.numSyllables:
		return true
	return false
	
func _sort_by_high_syllables(a, b) -> bool:
	if a.numSyllables > b.numSyllables:
		return true
	return false
