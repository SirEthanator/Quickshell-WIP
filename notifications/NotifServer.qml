pragma Singleton

import Quickshell;
import Quickshell.Services.Notifications;
import QtQuick;

Singleton {
  id: root

  readonly property alias notifList: server.trackedNotifications;

  signal incoming(n: Notification)
  signal dismissed(id: int)

  NotificationServer {
    id: server

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
}

