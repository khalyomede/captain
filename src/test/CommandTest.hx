package test;

import utest.Assert;
import utest.Test;

@:nullSafety(Strict)
final class CommandTest extends Test {
	function testNoOptionsNorArguments() {
		final code = this.runCommand("NoOptionsNorArguments");

		Assert.equals(0, code);
	}

	function testOneArgument() {
		final code = this.runCommand("OneArgument make command");

		Assert.equals(0, code);
	}

	function testOneBooleanOption() {
		final code = this.runCommand("OneBooleanOption --help");
		final code2 = this.runCommand("OneBooleanOption -h");

		Assert.equals(0, code);
		Assert.equals(0, code2);
	}

	function testOneBooleanOptionFallback() {
		final code = this.runCommand("OneBooleanOptionFallback");

		Assert.equals(0, code);
	}

	function testOneOption() {
		final code = this.runCommand("OneOption --quality 40");
		final code2 = this.runCommand("OneOption -q 40");

		Assert.equals(0, code);
		Assert.equals(0, code2);
	}

	function testOneBooleanOptionAndOneArgument() {
		final code = this.runCommand("OneBooleanOptionAndOneArgument make --version");
		final code2 = this.runCommand("OneBooleanOptionAndOneArgument make -v");
		final code3 = this.runCommand("OneBooleanOptionAndOneArgument --version make");
		final code4 = this.runCommand("OneBooleanOptionAndOneArgument -v make");

		Assert.equals(0, code);
		Assert.equals(0, code2);
		Assert.equals(0, code3);
		Assert.equals(0, code4);
	}

	function testOneOptionAndOneArgument() {
		final code = this.runCommand("OneOptionAndOneArgument compress --quality 40");
		final code2 = this.runCommand("OneOptionAndOneArgument compress -q 40");
		final code3 = this.runCommand("OneOptionAndOneArgument --quality 40 compress");
		final code4 = this.runCommand("OneOptionAndOneArgument -q 40 compress");

		Assert.equals(0, code);
		Assert.equals(0, code2);
		Assert.equals(0, code3);
		Assert.equals(0, code4);
	}

	public function testGetHelp() {
		final code = this.runCommand("Instructions");

		Assert.equals(0, code);
	}

	function runCommand(command: String): Int {
		return Sys.command('cd .. && haxe --cwd src --run test.misc.$command');
	}
}
