pragma Singleton

import Quickshell;
import Quickshell.Services.Notifications;
import QtQuick;

Singleton {
  id: root

  signal incoming(n: Notification);
  signal dismissed(id: int);

  readonly property alias notifList: notifServer.trackedNotifications;

  property list<int> unreadIds: [];
  readonly property int unreadCount: unreadIds.length;

  readonly property string icon: unreadCount > 0 ? "notification-new-symbolic" : "notifications-symbolic";

  function read(id: int) {
    root.unreadIds = root.unreadIds.filter((i) => i !== id);
  }

  NotificationServer {
    id: notifServer

    actionIconsSupported: true;
    actionsSupported: true;
    persistenceSupported: true;

    onNotification: n => {
      n.tracked = true;

      root.incoming(n);
      if (!n.transient) {
        root.unreadIds.push(n.id);
      }

      n.closed.connect(() => {
        root.dismissed(n.id);
        root.read(n.id);
      })

    }
  }

  readonly property alias server: notifServer;
}
