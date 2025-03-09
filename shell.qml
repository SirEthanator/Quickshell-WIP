//@ pragma UseQApplication

import Quickshell;
import "bar" as Bar;
import "menu" as Menu;
import "background" as Background;
import Quickshell.Io;

ShellRoot {
  id: shellroot;

  // --- Keybindings ---
  // Usage: quickshell ipc call <target> <function>
  IpcHandler {
    target: "menu";
    function toggle(): void { Globals.states.menuOpen = !Globals.states.menuOpen }
  }

	Variants {
		model: Quickshell.screens;

    Scope {
      id: scope;
      required property var modelData;

      Bar.Index {
        screen: scope.modelData;
      }

      Menu.Index {
        screen: scope.modelData;
      }

      Background.Index {
        screen: scope.modelData;
      }
    }

	}
}

