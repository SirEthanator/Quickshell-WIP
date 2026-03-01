import QtQuick;
import qs.utils as Utils;

QtObject {
  id: root;

  readonly property BarModule workspaces: BarModule {
    title: "Workspaces";
    moduleName: "Workspaces";
    props: ["screen"];
  }
  readonly property BarModule tray: BarModule {
    title: "System Tray";
    moduleName: "SysTray";
    props: ["window"];
  }
  readonly property BarModule menu: BarModule {
    title: "Menu Button";
    moduleName: "MenuBtn";
  }
  readonly property BarModule activeWindow: BarModule {
    title: "Active Window";
    moduleName: "ActiveWindow";
  }
  readonly property BarModule dateAndTime: BarModule {
    title: "Date & Time";
    moduleName: "DateAndTime";
  }
  readonly property BarModule network: BarModule {
    title: "Network";
    moduleName: "Network";
  }
  readonly property BarModule battery: BarModule {
    title: "Battery";
    moduleName: "Battery";
  }
  readonly property BarModule media: BarModule {
    title: "Media";
    moduleName: "Media";
  }
  readonly property BarModule volume: BarModule {
    title: "Volume";
    moduleName: "Volume";
  }
  readonly property BarModule notifications: BarModule {
    title: "Notifications";
    moduleName: "Notifications";
  }

  function toStripped(): var {
    return Utils.StripMeta.stripMeta(root);
  }
}
