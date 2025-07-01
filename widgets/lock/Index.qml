pragma ComponentBehavior: Bound

import "root:/";
import Quickshell;
import Quickshell.Io;
import Quickshell.Wayland;

Scope {
  LazyLoader {
    id: loader;
    activeAsync: false;

    WlSessionLock {
      id: lock;
      locked: true;
      onLockedChanged: { if (!locked) loader.activeAsync = false }

      function unlock() {
        locked = false;
      }

      Surface { lock: lock }
    }
  }

  IpcHandler {
    target: "lock";

    function lock(): void {
      loader.activeAsync = true;
    }
    function status(): bool {
      return loader.activeAsync
    }
  }
}

