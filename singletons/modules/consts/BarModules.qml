import QtQuick;
import qs.utils as Utils;

QtObject {
  id: root;

  readonly property BarModule workspaces: BarModule {
    title: "Workspaces";
    url: "Workspaces.qml";
    props: ["screen"];
  }
  readonly property BarModule tray: BarModule {
    title: "System Tray";
    url: "SysTray.qml";
    props: ["window"];
  }
  readonly property BarModule menu: BarModule {
    title: "Menu Button";
    url: "MenuBtn.qml";
  }
  readonly property BarModule activeWindow: BarModule {
    title: "Active Window";
    url: "ActiveWindow.qml";
  }
  readonly property BarModule dateAndTime: BarModule {
    title: "Date & Time";
    url: "DateAndTime.qml";
  }
  readonly property BarModule network: BarModule {
    title: "Network";
    url: "Network.qml";
  }
  readonly property BarModule battery: BarModule {
    title: "Battery";
    url: "Battery.qml";
  }
  readonly property BarModule media: BarModule {
    title: "Media";
    url: "Media.qml";
  }
  readonly property BarModule volume: BarModule {
    title: "Volume";
    url: "Volume.qml";
  }

  function toStripped(): var {
    return Utils.StripMeta.stripMeta(root);
  }
}
