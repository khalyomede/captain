package test.misc;

import captain.Command;
import haxe.Log;

@:nullSafety(Strict)
final class Instructions {
	public static function main() {
		final command = new Command(Sys.args());

		command.name = "fng";
		command.version = "0.1.0";

		command.arguments = [
			{
				name: "action",
				description: "The kind of action to perform.",
			},
			{
				name: "handler",
				description: 'The nature of the action to trigger. With make: one of "Middleware", "Model" or "Controller". With new: the name of your project.',
			},
		];

		command.options = [
			{
				name: "help",
				shortName: "h",
				description: "Display this help text.",
				boolean: true,
			},
			{
				name: "version",
				shortName: "v",
				boolean: true,
				description: "Display the version and build date.",
			},
			{
				name: "namespace",
				shortName: "n",
				description: "A custom namespace to use instead of the default.",
				required: true,
			},
		];

		final actual = command.getInstructions();

		final expected = [
			"Usage: fng <action> <handler> [options]",
			"",
			"Arguments:",
			"  action           The kind of action to perform.",
			'  handler          The nature of the action to trigger. With make: one of "Middleware", "Model" or "Controller". With new: the name of your project.',
			"",
			"Options:",
			"  --namespace, -n  (required) A custom namespace to use instead of the default.",
			"  --help, -h       (optional) Display this help text.",
			"  --version, -v    (optional) Display the version and build date.",
		].join("\n");

		if (actual == expected) {
			Sys.exit(0);

			return;
		}

		Sys.exit(1);
	}
}
