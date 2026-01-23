pragma Singleton

import Quickshell;

Singleton {
  id: root;

  readonly property string scriptPath: `${Quickshell.env("HOME")}/Scripts/SetTheme`;

  function setTheme(theme: string, args: string): void {
    Quickshell.execDetached(["sh", "-c", `${scriptPath} ${theme} --noconfirm ${args}`]);
  }
}
