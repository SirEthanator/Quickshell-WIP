import qs
import qs.components
import qs.animations as Anims;
import qs.widgets.notifications as Notifs;
import Quickshell.Services.Notifications;
import QtQuick;
import QtQuick.Controls;
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
    spacing: Globals.vars.notifPopupSpacing;
    visible: root.notifications.length > 0;

    RowLayout {
      id: buttons;

      Button {
        label: "Clear All";
        allRadius: true;

        onClicked: {
          for (const notif of root.notifications) { notif.dismiss() }
          emptyFadeInAnim.start();
        }
      }
    }

    ScrollView {
      id: scrollView;
      Layout.fillWidth: true;
      Layout.fillHeight: true;
      ScrollBar.vertical: StyledScrollBar { scrollView: scrollView }
      clip: true;

      ListView {
        id: list;
        anchors.fill: parent;
        spacing: Globals.vars.notifPopupSpacing;
        boundsBehavior: Flickable.StopAtBounds;
        cacheBuffer: 0;

        model: root.notifications;

        delegate: Notifs.Toast {
          required property Notification modelData;
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
    spacing: Globals.vars.paddingCard;

    Anims.NumberAnim {
      id: emptyFadeInAnim;
      target: empty;
      property: "opacity";
      from: 0; to: 1;
      duration: 1500;
    }

    Icon {
      icon: "no-notifications-symbolic";
      color: Globals.colours.grey;
      size: Globals.vars.extraLargeIconSize;
      Layout.alignment: Qt.AlignHCenter;
    }

    Text {
      text: "No Notifications";
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.smallHeadingFontSize;
      }
      color: Globals.colours.grey;
      Layout.fillWidth: true;
      horizontalAlignment: Text.AlignHCenter;
    }
  }
}

