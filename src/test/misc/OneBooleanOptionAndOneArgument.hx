package test.misc;

import captain.Command;

@:nullSafety(Strict)
final class OneBooleanOptionAndOneArgument {
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
				name: "version",
				shortName: "v",
				boolean: true,
				description: "Display the version and build date.",
			},
		];

		final action = switch (command.getArgument("action")) {
			case Some(value): value;
			case None: "";
		};

		final version = switch (command.getOption("version")) {
			case Some(value): value;
			case None: "false";
		};

		if (action == "make" && version == "true") {
			Sys.exit(0);

			return;
		}

		Sys.exit(1);
	}
}
