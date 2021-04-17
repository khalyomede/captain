# Captain

An opiniated command line parser that supports options and arguments.

## Summary

- [About](#about)
- [Features](#features)
- [Installation](#installation)
- [Examples](#examples)

## About

Captain is a Haxe library to parse command line arguments.

## Feature

- Lets you define which arguments you expect using a class
- Supports arguments and options with or without values
- Can define if an option is required (only for the purpose of the help text documentation)
- Generates the textual documentation based on your arguments and options definitions
- Uses the Haxe [Option](Option) data structure to get options and arguments and check if they are provided

## Installation

In your haxe project folder, run this command:

```bash
haxelib install captain
```

## Examples

All these example assume you have the following folder structure:

```txt
.
└── src/
  └── Main.hx
```

- [1. Get an argument](#1-get-an-argument)
- [2. Get an option](#2-get-an-option)
- [3. Display instructions](#3-display-instructions)
- [4. Define boolean options](#4-define-boolean-options)
- [5. Define required options](#5-define-required-options)

### 1. Get an argument

In this example, we will define and get an argument from the command line.

```haxe
// src/Main.hx

import captain.Command;
import haxe.ds.Option;

final class Main {
  public static function main() {
  final command = new Command(Sys.args());

  command.arguments = [
    {
    name: "firstname",
    description: "Your first name.",
    },
  ];

  final firstname = switch (command.getArgument("firstname")) {
    case Some(value): value;
    case None: "N/A";
  };

  trace('Your first name is $firstname.');
  }
}
```

To test it, run this command:

```bash
> haxe --cwd src --library captain --run Main John
Your first name is John.
```

### 2. Get an option

In this example, we will get an option from the command line.

```haxe
// src/Main.hx

import captain.Command;
import haxe.ds.Option;

final class Main {
  public static function main() {
    final command = new Command();

    command.options = [
      {
        name: "date",
        shortName: "d",
        description: "The date to display.",
      }
    ];

    final date = switch (command.getOption("date")) {
      case Some(value): value;
      case None: "N/A";
    };

    trace('The date is $date.');
  }
}
```

To test it, run this command:

```bash
> haxe --cwd src --library captain --run Main --date 2021-04-17
The date is 2021-04-17.
```

### 3. Display instructions

In this example, we will listen for the "--help" or "-h" option, and display the command instructions.

```haxe
// src/Main.hx

import captain.Command;
import haxe.ds.Option;

final class Main {
  public static function main() {
    final command = new Command();

    command.name = "cmd";
    command.arguments = [
      {
        name: "firstname",
        description: "Your first name.",
      }
    ];
    command.options = [
      {
        name: "help",
        shortName: "h",
        boolean: true,
        description: "Display this help text.",
      },
      {
        name: "date",
        shortName: "d",
        description: "The date to display.",
        required: true,
      }
    ];

    final firstName = switch (command.getArgument("firstname")) {
      case Some(value): value;
      case None: "N/A";
    };

    final date = switch (command.getOption("date")) {
      case Some(value): value;
      case None: "N/A";
    };

    final displayHelp = switch (command.getOption("help")) {
      case Some(value): true;
      case None: false;
    };

    if (displayHelp) {
      trace(command.getInstructions());
    } else {
      trace('Your first name is $firstName and the date is $date.');
    }
  }
}
```

Now to test the help instructions, run this in your terminal:

```bash
> haxe --cwd src --library captain --run Main --help
Usage: cmd <firstname> [options]

Arguments:
  firstname   Your first name.

Options:
  --date, -d  (required) The date to display.
  --help, -h  (optional) Display this help text.
```

### 4. Define boolean options

In this example, we will define a boolean option (or often called "flag") and get its value from the command line arguments.

```haxe
// src/Main.hx

import captain.Command;
import haxe.ds.Option;

final class Main {
  public static function main() {
    final command = new Command(Sys.args());

    command.name = "cmd";
    command.options = [
      {
        name: "version",
        shortName: "v",
        boolean: true,
      },
    ];

    final displayVersion = switch (command.getOption("version")) {
      case Some(value): true;
      case None: false;
    };

    if (displayVersion) {
      trace('${command.name} version 0.1.0 (build 2021-04-17)');
    }
  }
}
```

To test it, run this in your terminal:

```haxe
> haxe --cwd src --library captain --run Main --version
cmd version 0.1.0 (build 2021-04-17)
```

Boolean options do not take any values.

### 5. Define required options

In this example, we will define a required option and get its value. Note that the required attribute is only used for displaying the option is required in the instructions (see example [3. Display instructions](#3-display-instructions)). This library does not perform command line argument validation.

```haxe
// src/Main.hx

import captain.Command;
import haxe.ds.Option;

final class Main {
  public static function main() {
    final command = new Command();

    command.optins = [
      {
        name: "date",
        shortName: "d",
        required: true,
      },
    ];

    final date = switch (command.getOption("date")) {
      case Some(value): value;
      case None: "N/A";
    };

    trace('The date is $date.');
  }
}
```

To test it, run this command in your terminal:

```bash
> haxe --cwd src --library captain --run Main --date 2021-04-17
The date is 2021-04-17.
```
