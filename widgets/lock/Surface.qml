import "root:/";
import "root:/components";
import Quickshell.Wayland;
import Quickshell.Services.Pam;
import QtQuick;
import QtQuick.Layouts;

WlSessionLockSurface {
  id: root;

  required property WlSessionLock lock;

  color: Globals.colours.bg;

  Pam {
    id: pam;
    lock: root.lock;
    onPasswordChanged: {
      if (password !== input.text) input.text = password;
    }
  }

  PassInput { id: input; pam: pam }
}

