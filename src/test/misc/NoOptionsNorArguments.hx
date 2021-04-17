package test.misc;

import captain.Command;

@:nullSafety(Strict)
final class NoOptionsNorArguments {
	public static function main() {
		final command = new Command(Sys.args());
		final arguments = command.getArguments();
		final options = command.getOptions();
		var numberOfArguments = 0;
		var numberOfOptions = 0;

		for (argument in arguments) {
			numberOfArguments++;

			break;
		}

		for (option in options) {
			numberOfOptions++;

			break;
		}

		if (numberOfArguments > 0 || numberOfOptions > 0) {
			Sys.exit(1);

			return;
		}

		Sys.exit(0);
	}
}
