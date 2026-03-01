import qs.singletons
import qs.widgets.bar
import qs.widgets.sidebar as Sidebar;
import qs.widgets.notifications as Notifs;
import QtQuick;

BarModule {
  id: root;

  icon: Notifs.NotifServer.unreadCount > 0 ? "notification-new-symbolic" : "notifications-symbolic";

  clickable: true;

  show: Notifs.NotifServer.notifList.values.length > 0;

  Text {
    text: Notifs.NotifServer.notifList.values.length;

    color: Globals.colours.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
  }

  onClicked: {
    Sidebar.Controller.toggle("notifications");
  }

  tooltip: Tooltip {
    Text {
      text: `${Notifs.NotifServer.notifList.values.length} notifications, ${Notifs.NotifServer.unreadCount} unread`;
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }
}
