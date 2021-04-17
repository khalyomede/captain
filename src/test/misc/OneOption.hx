package test.misc;

import captain.Command;

@:nullSafety(Strict)
final class OneOption {
	public static function main() {
		final command = new Command(Sys.args());

		command.options = [
			{
				name: "quality",
				shortName: "q",
				description: "The desired image quality after compression.",
			},
		];

		final quality = switch (command.getOption("quality")) {
			case Some(value): value;
			case None: "80";
		};

		if (quality == "40") {
			Sys.exit(0);

			return;
		}

		Sys.exit(1);
	}
}
