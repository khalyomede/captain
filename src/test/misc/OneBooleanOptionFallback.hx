package test.misc;

import captain.Command;

@:nullSafety(Strict)
final class OneBooleanOptionFallback {
	public static function main() {
		final command = new Command(Sys.args());

		command.options = [
			{
				name: "help",
				shortName: "h",
				boolean: true,
				description: "To display this help text.",
			}
		];

		final help = switch (command.getOption("help")) {
			case Some(value): value;
			case None: "false";
		};

		if (help == "false") {
			Sys.exit(0);

			return;
		}

		Sys.exit(1);
	}
}
