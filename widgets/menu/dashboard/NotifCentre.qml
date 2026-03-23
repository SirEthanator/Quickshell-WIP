import qs.singletons
import qs.components
import qs.panels.notifications as Notifs;
import qs.widgets.notifications as NotifWidgets;
import Quickshell.Services.Notifications;
import QtQuick;
import QtQuick.Controls as Ctrls;
import QtQuick.Layouts;

DashItem {
  id: root;
  Layout.fillHeight: true;
  fullContentWidth: true;

  readonly property var notifications: Notifs.NotifServer.notifList.values;

  ColumnLayout {
    id: column;
    Layout.fillWidth: true;
    Layout.fillHeight: true;
    spacing: Consts.paddingMedium;
    visible: root.notifications.length > 0;

    RowLayout {
      id: buttons;

      Button {
        label: "Clear all";
        allRadius: true;

        onClicked: {
          for (const notif of root.notifications) { notif.dismiss() }
        }
      }
    }

    Ctrls.ScrollView {
      id: scrollView;
      Layout.fillWidth: true;
      Layout.fillHeight: true;
      Ctrls.ScrollBar.vertical: StyledScrollBar { scrollView: scrollView }
      clip: true;

      ListView {
        id: list;
        anchors.fill: parent;
        spacing: Consts.paddingMedium;
        boundsBehavior: Flickable.StopAtBounds;
        cacheBuffer: 0;

        model: root.notifications;

        delegate: NotifWidgets.Toast {
          required property Notification modelData;
          showOutline: Conf.sidebar.moduleOutlines;
          n: modelData;
        }
      }
    }
  }

  ColumnLayout {
    id: empty;
    visible: !column.visible;
    Layout.fillHeight: true;
    Layout.fillWidth: true;
    spacing: Consts.paddingLarge;

    Icon {
      icon: "no-notifications-symbolic";
      color: Colors.c.grey;
      size: Consts.iconSizeXLarge;
      Layout.alignment: Qt.AlignHCenter;
    }

    Text {
      text: "No notifications";
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeSmallLarge;
      }
      color: Colors.c.grey;
      Layout.fillWidth: true;
      horizontalAlignment: Text.AlignHCenter;
    }
  }
}

