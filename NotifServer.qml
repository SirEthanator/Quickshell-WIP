pragma Singleton

import Quickshell;
import Quickshell.Services.Notifications;
import QtQuick;

Singleton {
  id: root

  signal incoming(n: Notification);
  signal dismissed(id: int);

  readonly property alias notifList: notifServer.trackedNotifications;

  NotificationServer {
    id: notifServer

    actionIconsSupported: true;
    actionsSupported: true;
    imageSupported: true;

    onNotification: n => {
      n.tracked = true;
      root.incoming(n);

      n.closed.connect(() => {
        root.dismissed(n.id)
      })

    }
  }

  readonly property alias server: notifServer;
}

