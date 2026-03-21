import qs.singletons
import qs.components
import qs.panels.notifications as Notifs
import QtQuick
import QtQuick.Layouts

Item {
  id: root;

  readonly property real padding: Consts.paddingModule;

  width: row.implicitWidth + padding * 2;
  height: row.implicitHeight + padding * 2;

  visible: Notifs.NotifServer.unreadCount > 0;

  Shadow { target: background }

  OutlinedRectangle {
    id: background;

    color: Colors.c.bg;
    radius: Consts.br;
    anchors.fill: parent;

    RowLayout {
      id: row;
      spacing: root.padding;

      anchors.centerIn: parent;

      Icon {
        icon: Notifs.NotifServer.icon;
        size: Consts.mainIconSize;
        color: Colors.c.fg;
      }

      Text {
        text: `${Notifs.NotifServer.unreadCount} new notifications`;
        color: Colors.c.fg;
        font {
          family: Consts.fontFamily;
          pixelSize: Consts.mainFontSize;
        }
      }
    }
  }
}
