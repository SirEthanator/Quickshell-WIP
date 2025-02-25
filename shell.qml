//@ pragma UseQApplication

import Quickshell;
import "bar" as Bar;
import "menu" as Menu;
import "dialog" as Dialog;
import Quickshell.Hyprland;

ShellRoot {
  id: shellroot;

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
          Globals.states.menuOpen = !Globals.states.menuOpen;
        }
      }

      Bar.Index {
        screen: scope.modelData;
      }

      Menu.Index {
        screen: scope.modelData;
        shellroot: shellroot;
      }
    }

	}
}

