pragma Singleton

import "root:/";
import "root:/utils" as Utils;
import Quickshell;
import Quickshell.Services.Notifications;
import QtQuick;

Singleton {
  id: root

  readonly property int defaultTimeout: 5000;

  // property list<Notification> notifList;
  property alias notifList: server.trackedNotifications;

  signal incoming(n: Notification)
  signal dismissed(id: int)

  NotificationServer {
    id: server

    actionIconsSupported: true;
    actionsSupported: true;
    bodyMarkupSupported: true;
    imageSupported: true;

    onNotification: n => {
      n.tracked = true;
      // root.notifList += n;
      root.incoming(n);

      const timer = Utils.Timeout.setTimeout(() => {
        // n.expire();
        root.dismissed(n.id)
      }, n.expireTimeout > 0 ? n.expireTimeout : root.defaultTimeout);

      n.closed.connect(() => {
        root.dismissed(n.id)
      })

    }
  }
}

