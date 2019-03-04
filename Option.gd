extends Object

var ID
var text
var response
var options #An array of OptionIDs


func _ready():
	options = []

func _init(_ID, _text, _response, _options): #takes in array of option ID's
	ID = _ID
	text = _text
	response = _response
	options = _options
	
