pragma Singleton

import "root:/";
import "root:/utils" as Utils;
import Quickshell;
import Quickshell.Services.Notifications;
import QtQuick;

Singleton {
  id: root

  readonly property int defaultTimeout: 5000;

  property alias notifList: server.trackedNotifications;

  signal incoming(n: Notification, timeout: real)
  signal dismissed(id: int)

  NotificationServer {
    id: server

    actionIconsSupported: true;
    actionsSupported: true;
    imageSupported: true;

    onNotification: n => {
      n.tracked = true;
      // root.notifList += n;
      const timeout = n.expireTimeout > 0 ? n.expireTimeout : root.defaultTimeout
      root.incoming(n, timeout);

      const timer = Utils.Timeout.setTimeout(() => {
        // n.expire();
        root.dismissed(n.id)
      }, timeout);

      n.closed.connect(() => {
        root.dismissed(n.id)
      })

    }
  }
}

