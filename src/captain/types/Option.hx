package captain.types;

/**
	Represents a command line option.
**/
typedef Option = {
	name: String,
	shortName: String,
	description: String,
	?boolean: Bool,
	?required: Bool,
};
