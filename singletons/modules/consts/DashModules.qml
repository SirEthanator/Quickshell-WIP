import QtQuick;
import qs.utils as Utils;

QtObject {
  id: root;

  readonly property DashModule userInfo: DashModule {
    title: "User Info & Power";
    url: "userinfo/Index.qml";
  }
  readonly property DashModule sysStats: DashModule {
    title: "System Stats";
    url: "sysstats/Index.qml";
  }
  readonly property DashModule notifCentre: DashModule {
    title: "Notification Centre";
    url: "NotifCentre.qml";
  }
  readonly property DashModule tray: DashModule {
    title: "System Tray";
    url: "SysTray.qml";
  }

  function toStripped(): var {
    return Utils.StripMeta.stripMeta(root);
  }
}
