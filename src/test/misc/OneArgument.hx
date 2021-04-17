package test.misc;

import captain.Command;

@:nullSafety(Strict)
final class OneArgument {
	public static function main() {
		final command = Command.fromArguments(Sys.args());

		command.arguments = [
			{
				name: "action",
				description: "The kind of action to perform.",
			}
		];

		final argument = switch (command.getArgument("action")) {
			case Some(value): value;
			case None: "";
		};
		final arguments = command.getArguments();
		var numberOfArguments = 0;

		for (argument in arguments) {
			numberOfArguments++;
		}

		if (numberOfArguments == 1 && argument == "make") {
			Sys.exit(0);

			return;
		}

		Sys.exit(1);
	}
}
