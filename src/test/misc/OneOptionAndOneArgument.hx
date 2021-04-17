package test.misc;

import captain.Command;

@:nullSafety(Strict)
final class OneOptionAndOneArgument {
	public static function main() {
		final command = new Command(Sys.args());

		command.arguments = [
			{
				name: "action",
				description: "The kind of action to perform.",
			}
		];

		command.options = [
			{
				name: "quality",
				shortName: "q",
				description: "The desired image quality after compression.",
			},
		];

		final action = switch (command.getArgument("action")) {
			case Some(value): value;
			case None: "";
		};

		final quality = switch (command.getOption("quality")) {
			case Some(value): value;
			case None: "80";
		};

		if (action == "compress" && quality == "40") {
			Sys.exit(0);

			return;
		}

		Sys.exit(1);
	}
}
