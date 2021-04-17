package captain;

import captain.types.Argument;
import captain.types.Option;
import haxe.ds.ArraySort;

/**
	Modelizes command line arguments.
**/
@:nullSafety(Strict)
final class Command {
	private static var LONG_OPTION_PREFIX = "--";
	private static var SHORT_OPTION_PREFIX = "-";

	public var name: String;
	public var arguments: Array<Argument>;
	public var options: Array<Option>;
	public var version: String;
	var commandLineArguments: Array<String>;

	public function new(commandLineArguments: Array<String>) {
		this.arguments = [];
		this.options = [];
		this.version = "";
		this.name = "";
		this.commandLineArguments = commandLineArguments;
	}

	public function getArguments(): Map<String, String> {
		var arguments: Map<String, String> = [];

		var ignoreNextOption = false;
		var ignoreNextArgument = false;
		var savedArguments: Array<String> = [];

		for (commandLineArgument in this.commandLineArguments) {
			if (ignoreNextOption) {
				ignoreNextOption = false;

				continue;
			}

			if (ignoreNextArgument) {
				ignoreNextArgument = false;

				if (!StringTools.startsWith(commandLineArgument, Command.SHORT_OPTION_PREFIX) && !StringTools.startsWith(commandLineArgument, Command.LONG_OPTION_PREFIX)) {
					continue;
				}
			}

			if (StringTools.startsWith(commandLineArgument, Command.SHORT_OPTION_PREFIX) || StringTools.startsWith(commandLineArgument, Command.LONG_OPTION_PREFIX)) {
				final isShortOption = !StringTools.startsWith(commandLineArgument, Command.LONG_OPTION_PREFIX);
				final prefix = isShortOption ? Command.SHORT_OPTION_PREFIX : Command.LONG_OPTION_PREFIX;
				final optionName = new EReg('^$prefix', "").replace(commandLineArgument, "");

				for (definedOption in this.options) {
					if (definedOption.name == optionName || (isShortOption && definedOption.shortName == optionName)) {
						if (definedOption.boolean == null || !definedOption.boolean) {
							ignoreNextOption = true;

							continue;
						}
					}
				}
			} else {
				for (argument in this.arguments) {
					if (savedArguments.contains(argument.name)) {
						continue;
					}

					savedArguments.push(argument.name);
					arguments[argument.name] = commandLineArgument;

					break;
				}
			}
		}

		return arguments;
	}

	public function getArgument(name: String): haxe.ds.Option<String> {
		final arguments = this.getArguments();

		if (arguments.exists(name)) {
			final value = arguments[name];

			if (value != null) {
				return haxe.ds.Option.Some(value);
			}
		}

		return haxe.ds.Option.None;
	}

	public function getOptions(): Map<String, String> {
		var options: Map<String, String> = [];

		var nextIsOptionValue = false;
		var nextOptionName = "";
		var savedOptions: Array<String> = [];

		for (commandLineArgument in this.commandLineArguments) {
			if (nextIsOptionValue) {
				nextIsOptionValue = false;

				if (StringTools.startsWith(commandLineArgument, Command.SHORT_OPTION_PREFIX) || StringTools.startsWith(commandLineArgument, Command.LONG_OPTION_PREFIX)) {
					continue;
				}

				savedOptions.push(nextOptionName);

				options[nextOptionName] = commandLineArgument;

				continue;
			}

			if (StringTools.startsWith(commandLineArgument, Command.SHORT_OPTION_PREFIX) || StringTools.startsWith(commandLineArgument, Command.LONG_OPTION_PREFIX)) {
				final isShortOption = !StringTools.startsWith(commandLineArgument, Command.LONG_OPTION_PREFIX);
				final prefix = isShortOption ? Command.SHORT_OPTION_PREFIX : Command.LONG_OPTION_PREFIX;
				final optionName = new EReg('^$prefix', "").replace(commandLineArgument, "");

				for (definedOption in this.options) {
					if (definedOption.name == optionName || (isShortOption && definedOption.shortName == optionName)) {
						if (definedOption.boolean != null && definedOption.boolean) {
							options[definedOption.name] = "true";

							continue;
						} else {
							nextIsOptionValue = true;
							nextOptionName = definedOption.name;

							continue;
						}
					}
				}
			} else {
				continue;
			}
		}

		return options;
	}

	public function getOption(name: String): haxe.ds.Option<String> {
		final options: Map<String, String> = this.getOptions();

		if (options.exists(name)) {
			final value = options[name];

			if (value != null) {
				return haxe.ds.Option.Some(value);
			}
		}

		return haxe.ds.Option.None;
	}

	public function getInstructions(): String {
		var instructions = 'Usage: ${this.name}';

		if (this.arguments.length > 0) {
			instructions += " " + this.arguments.map(argument -> '<${argument.name}>').join(" ");
		}

		if (this.options.length > 0) {
			instructions += " [options]";
		}

		var maxOptionOrArgumentLength = 0;

		for (argument in this.arguments) {
			if (argument.name.length > maxOptionOrArgumentLength) {
				maxOptionOrArgumentLength = argument.name.length;
			}
		}

		for (option in this.options) {
			if ((option.name.length + 5) > maxOptionOrArgumentLength) {
				maxOptionOrArgumentLength = option.name.length;
			}
		}

		if (this.arguments.length > 0) {
			instructions += "\n\nArguments:";

			for (argument in this.arguments) {
				final spacesToAdd = maxOptionOrArgumentLength - (argument.name.length) + 6;

				instructions += '\n  ${argument.name}';

				for (_ in 0...spacesToAdd) {
					instructions += " ";
				}

				instructions += '  ${argument.description}';
			}
		}

		var options = this.options;

		ArraySort.sort(options, (a, b) -> {
			var returnValue = 0;

			// Option A is required, Option B is not required: Option A is sorted up
			if (a.required != null && a.required && (b.required == null || !b.required)) {
				returnValue = -1;
			}

			// Option A is not required, Option B is required: Option B is sorted up
			if ((a.required == null || !a.required) && b.required != null && b.required) {
				returnValue = 1;
			}

			return returnValue;
		});

		if (this.options.length > 0) {
			instructions += "\n\nOptions:";

			for (option in options) {
				final spacesToAdd = maxOptionOrArgumentLength - (option.name.length);

				instructions += '\n  --${option.name}, -${option.shortName}';

				for (_ in 0...spacesToAdd) {
					instructions += " ";
				}

				instructions += option.required != null && option.required ? "  (required)" : "  (optional)";

				instructions += ' ${option.description}';
			}
		}

		return instructions;
	}

	public static function fromArguments(commandLineArguments: Array<String>): Command {
		return new Command(commandLineArguments);
	}
}
