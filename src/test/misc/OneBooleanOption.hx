package test.misc;

import captain.Command;

@:nullSafety(Strict)
final class OneBooleanOption {
	public static function main() {
		final command = new Command(Sys.args());

		command.options = [
			{
				name: "help",
				shortName: "h",
				boolean: true,
				description: "To display this help text.",
			},
		];

		var numberOfOptions = 0;

		for (option in command.getOptions()) {
			numberOfOptions++;
		}

		final help = switch (command.getOption("help")) {
			case Some(value): value;
			case None: "false";
		};

		if (numberOfOptions == 1 && help == "true") {
			Sys.exit(0);

			return;
		}

		Sys.exit(1);
	}
}
