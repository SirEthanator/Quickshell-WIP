//@ pragma UseQApplication

import Quickshell;
import "bar" as Bar;
import "sidebar" as Sidebar;

ShellRoot {
	Variants {
		model: Quickshell.screens;

    Scope {
      id: scope;
      required property var modelData;

      Bar.Index {
        screen: scope.modelData;
      }

      Sidebar.Index {
        screen: scope.modelData;
      }
    }

	}
}

