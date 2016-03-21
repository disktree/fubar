package fubar;

import om.api.Giphy;

/*
enum ConfigFieldType {
	string;
	integer;
	float;
}

typedef ConfigField = {
	var name : String;
	var type : ConfigFieldType;
	var default : ConfigFieldType;
}

class Config implements om.app.Config {

	var limit = {
		type: integer,
		min: 1,
		max: 1000,
		_default: null,
		description: 'Set the maximum items to load per session'
	};

	//var limit = @range([1,1000]) 10;

	//var rating : om.api.Giphy.Rating;
}
*/

typedef Config = {
	var limit : Int;
	var rating : Rating;
}
