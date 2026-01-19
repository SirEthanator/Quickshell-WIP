pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.utils as Utils;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

GridLayout {
  id: root;
  columns: 3;
  rows: 2;
  columnSpacing: Consts.spacingButtonGroup;
  rowSpacing: Consts.spacingButtonGroup;
  uniformCellWidths: true;
  uniformCellHeights: true;

  signal goBack;
  signal launchConfirmation;

  property var selectedAction;

  Repeater {
    id: repeater;
    model: [
      { icon: 'back-symbolic', action: root.goBack },
      { title: 'Shut down', titleFuture: 'Shutting down', icon: 'system-shutdown-symbolic', command: 'systemctl poweroff' },
      { title: 'Reboot', titleFuture: 'Rebooting', icon: 'system-reboot-symbolic', command: 'systemctl reboot' },
      { title: 'Log out', titleFuture: 'Logging out', icon: 'logout-symbolic', action: Utils.Session.logOut },
      { title: 'Suspend', titleFuture: 'Suspending', icon: 'system-hibernate-symbolic', command: 'loginctl lock-session & sleep 1; systemctl suspend' },
      { title: 'Reboot to FW settings', titleFuture: 'Rebooting to FW settings', icon: 'preferences-advanced-symbolic', command: 'systemctl reboot --firmware-setup' }
    ]

    Button {
      id: powerBtn;
      required property var modelData;
      required property int index;
      icon: modelData.icon;
      Layout.fillWidth: true;
      Layout.fillHeight: true;

      tlRadius: index === 0;
      trRadius: index === 2;
      blRadius: index === 3;
      brRadius: index === 5;

      padding: Consts.paddingButtonIcon;

      Process { id: powerCmd }
      onClicked: {
        const action = modelData.action;
        const hasText = !!modelData.title && !!modelData.titleFuture;
        if (!!action && !hasText) action();
        else if (hasText) {
          root.selectedAction = modelData;
          root.launchConfirmation();
        }
      }
    }
  }
}

