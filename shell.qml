//@ pragma UseQApplication

import Quickshell;
import "bar" as Bar;
import "menu" as Menu;
import Quickshell.Io;

ShellRoot {
  id: shellroot;

	Variants {
		model: Quickshell.screens;

    Scope {
      id: scope;
      required property var modelData;

      // --- Keybindings ---
      // Usage: quickshell ipc call <target> <function>
      IpcHandler {
        target: "menu";
        function toggle(): void { Globals.states.menuOpen = !Globals.states.menuOpen }
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

