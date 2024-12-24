extends Node

signal rhymes_retrieved(results: Array)
signal sorted

const BASE_URL = "https://api.datamuse.com/words?"
@onready var rhyme: HTTPRequest = $Rhyme

var rhymes = []

func _ready():
	rhyme.request_completed.connect(_on_rhyme_request_completed)

func rhyme_request(word: String):
	rhyme.request(BASE_URL + "sl=" + word)

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
