//@ pragma UseQApplication

import Quickshell;
import "bar" as Bar;

ShellRoot {
	Variants {
		model: Quickshell.screens;

		Bar.Index {
			required property var modelData;
			screen: modelData;
		}
	}
}

