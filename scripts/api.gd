extends Node

signal rhyme_retrieved(results: Array)
signal adjective_retrieved(results: Array)
signal sound_alike_retrieved(results: Array)
signal noun_retrieved(results: Array)
signal word_retrieved(results: Array)
signal synonym_retrieved(results: Array)
signal antonym_retrieved(results: Array)
signal freq_follower_retrieved(results: Array)

const REQUEST_TYPES = {
	"rhyme": "rel_rhy",
	"adjective": "rel_jjb",
	"sound_alike": "rel_nry",
	"noun": "rel_nry",
	"word": "rel_trg",
	"synonym": "rel_syn",
	"antonym": "rel_ant",
	"freq_follower": "rel_bga"
}
const BASE_URL = "https://api.datamuse.com/words?"
const END_URL = "&v=enwiki&max=50"

# Store HTTP requests and results
var requests = {}
var results = {}

func _ready():
	# Create HTTPRequest nodes and connect signals for each type
	for request_type in REQUEST_TYPES.keys():
		var http_request = HTTPRequest.new()
		add_child(http_request)
		requests[request_type] = http_request
		results[request_type] = []
		
		# Connect completion signal
		http_request.request_completed.connect(
			func(result, response_code, headers, body): 
				_on_request_completed(result, response_code, headers, body, request_type)
		)

# Generic request function
func make_request(request_type: String, word: String) -> void:
	if not REQUEST_TYPES.has(request_type):
		push_error("Invalid request type: " + request_type)
		return
		
	var param = REQUEST_TYPES[request_type]
	var url = BASE_URL + param + "=" + word + END_URL
	requests[request_type].request(url)

# Generic completion handler
func _on_request_completed(result, response_code, headers, body, request_type: String) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	results[request_type] = json
	
	# Emit signal dynamically
	var signal_name = request_type + "_retrieved"
	emit_signal(signal_name, results[request_type])

# Sorting methods
enum SortMethod {
	LOW_SCORE,
	HIGH_SCORE,
	LOW_SYLLABLES,
	HIGH_SYLLABLES
}

func sort_results(array_name: String, method: SortMethod) -> Array:
	if not results.has(array_name):
		return []
		
	var active_array = results[array_name].duplicate()
	
	match method:
		SortMethod.LOW_SCORE:
			active_array.sort_custom(func(a, b): return a.score < b.score)
		SortMethod.HIGH_SCORE:
			active_array.sort_custom(func(a, b): return a.score > b.score)
		SortMethod.LOW_SYLLABLES:
			active_array.sort_custom(func(a, b): return a.numSyllables < b.numSyllables)
		SortMethod.HIGH_SYLLABLES:
			active_array.sort_custom(func(a, b): return a.numSyllables > b.numSyllables)
			
	return active_array

# Convenience methods for each request type
func rhyme_request(word: String): make_request("rhyme", word)
func adjective_request(word: String): make_request("adjective", word)
func sound_alike_request(word: String): make_request("sound_alike", word)
func noun_request(word: String): make_request("noun", word)
func word_request(word: String): make_request("word", word)
func synonym_request(word: String): make_request("synonym", word)
func antonym_request(word: String): make_request("antonym", word)
func freq_follower_request(word: String): make_request("freq_follower", word)
