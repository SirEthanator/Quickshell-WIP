pragma Singleton
pragma ComponentBehavior: Bound

import qs.singletons
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;

  property real brightnessPercent: -1;
  property int maxBrightness: -1;

  readonly property string icon: root.brightnessPercent >= .5
    ? "brightness-high-symbolic"
    : "brightness-low-symbolic";

  // TODO: Add readonly bool canChange

  function setBrightness(percentage: real): void {
    if (!brightnessLoader.status === Loader.Ready) return;
    brightnessLoader.item.setBrightness(percentage);
  }

  function incrementBrightness(percentage: real): void {
    if (!brightnessLoader.status === Loader.Ready) return;
    brightnessLoader.item.incrementBrightness(percentage);
  }

  IpcHandler {
    target: "brightness";

    function set(value: int): void {
      root.setBrightness(value / 100)
    }

    function increment(value: int): void {
      root.incrementBrightness(value / 100);
    }

    function decrement(value: int): void {
      root.incrementBrightness(-value / 100)
    }
  }

  Loader {
    id: brightnessLoader;
    active: Conf.osd.backlightName !== "";

    sourceComponent: Item {
      function setBrightness(percentage: real): void {
        if (root.maxBrightness === -1 || !brightnessFile.loaded) return;

        const targetVal = root.maxBrightness * percentage;
        const newVal = Math.round(Math.max(Math.min(targetVal, root.maxBrightness), 0));
        brightnessFile.setText(newVal.toString());
      }

      function incrementBrightness(percentage: real): void {
        if (root.brightnessPercent === -1) return;
        setBrightness(root.brightnessPercent + percentage);
      }

      FileView {
        id: brightnessFile;
        path: Qt.resolvedUrl(`/sys/class/backlight/${Conf.osd.backlightName}/brightness`);
        blockLoading: true;
        watchChanges: true;

        // Must be disabled because atomicWrites tries to use a temporary
        // file then replace the brightness file with it. This is not allowed.
        atomicWrites: false;

        function updateBrightness() {
          if (root.maxBrightness === -1 || !loaded) return;
          root.brightnessPercent = Math.round(Number.parseInt(brightnessFile.text()) / root.maxBrightness * 100) / 100;
        }

        onFileChanged: {
          brightnessFile.reload();
          brightnessFile.waitForJob();
          updateBrightness();
        }

        onLoaded: updateBrightness();

        printErrors: false;

        onLoadFailed: {
          console.warn(`Failed to load brightness file from: ${path}`);
        }
      }

      Process {
        command: ["cat", `/sys/class/backlight/${Conf.osd.backlightName}/max_brightness`];
        running: true;
        stdout: SplitParser {
          onRead: (data) => {
            root.maxBrightness = Number.parseInt(data);
            brightnessFile.updateBrightness();
          }
        }
      }
    }
  }
}
