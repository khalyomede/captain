package test;

import utest.Runner;
import utest.ui.Report;

@:nullSafety(Strict)
final class Main {
	public static function main() {
		final runner = new Runner();

		runner.addCase(new CommandTest());

		Report.create(runner);

		runner.run();
	}
}
