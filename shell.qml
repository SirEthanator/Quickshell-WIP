//@ pragma UseQApplication

import Quickshell;
import "bar" as Bar;
import "sidebar" as Sidebar;
import Quickshell.Hyprland;

ShellRoot {
	Variants {
		model: Quickshell.screens;

    Scope {
      id: scope;
      required property var modelData;

      // Hyprland keybindings
      GlobalShortcut {
        name: "menu";
        description: "Opens the side menu on Quickshell.";
        onReleased: {
          Globals.states.sidebarOpen = !Globals.states.sidebarOpen;
        }
      }

      Bar.Index {
        screen: scope.modelData;
      }

      Sidebar.Index {
        screen: scope.modelData;
      }
    }

	}
}

