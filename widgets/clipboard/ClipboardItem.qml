import qs.singletons
import qs.components
import qs.widgets.clipboard
import qs.animations as Anims;
import QtQuick;

Item {
  id: root;
  required property string value;
  required property int index;

  readonly property bool isCurrent: index === Controller.currentIndex;

  height: itemText.implicitHeight + Consts.paddingButton * 2;
  width: parent.width;

  function del() {
    deleteAnim.restart();
  }

  Item {
    id: container;
    clip: true;

    height: parent.height;
    width: parent.width;

    Item {
      id: background;

      height: parent.height;
      width: parent.width;

      x: 0;

      Anims.NumberTransition on x {}

      SequentialAnimation {
        id: deleteAnim;

        Anims.NumberAnim {
          target: background;
          property: "x";
          to: background.width * (background.x > 0 ? 1 : -1);
        }

        PauseAnimation { duration: 100 }

        ScriptAction {
          script: Controller.del(root.index);
        }
      }

      OutlinedRectangle {
        id: mainBackground;
        color: mouse.drag.active
          ? Colors.c.bgLight
          : mouse.containsPress
            ? Colors.c.accent
            : mouse.containsMouse || root.isCurrent
              ? Colors.c.bgHover
              : Colors.c.bgLight;

        disableAllOutlines: !Conf.sidebar.moduleOutlines;
        radius: Math.abs(parent.x) > 0 ? 0 : Consts.br;

        width: parent.width;
        height: parent.height;

        x: 0;

        Anims.ColorTransition on color {}
        Anims.NumberTransition on radius {}

        Text {
          id: itemText;
          text: root.value.replace(/^\d+\s+/, "");

          anchors {
            verticalCenter: parent.verticalCenter;
            left: parent.left;
            right: parent.right;
            margins: Consts.paddingLarge;
          }

          color: !mouse.drag.active && mouse.containsPress ? Colors.c.bgLight : Colors.c.fg;
          font {
            family: Consts.fontFamMain;
            pixelSize: Consts.fontSizeMain;
          }

          maximumLineCount: 1;
          clip: true;
        }
      }

      OutlinedRectangle {
        id: deleteBackground;

        color: mouse.atThreshold ? Colors.c.red : Colors.c.bgRed;
        disableAllOutlines: mainBackground.disableAllOutlines;
        radius: mainBackground.radius;

        height: parent.height;
        width: parent.width;

        x: parent.x > 0 ? -width : width;

        Anims.ColorTransition on color {}
        Anims.NumberTransition on radius {}

        Icon {
          icon: "delete-symbolic";
          color: mouse.atThreshold ? Colors.c.bgRed : Colors.c.red;
          size: Consts.iconSizeMain;

          Anims.ColorTransition on color {}

          x: parent.x < 0 ? parent.width - size - Consts.paddingLarge : Consts.paddingLarge;

          anchors {
            verticalCenter: parent.verticalCenter;
          }
        }
      }
    }

    MouseArea {
      id: mouse
      anchors.fill: parent;
      hoverEnabled: true;

      onClicked: Controller.select(root.index);

      readonly property real deleteThreshold: 0.25;
      readonly property bool atThreshold: Math.abs(drag.target.x) >= drag.target.width * deleteThreshold;

      drag {
        target: background;
        axis: Drag.XAxis;
        maximumX: drag.target.width;
        minimumX: -drag.target.width;
        threshold: 15;
      }

      onReleased: (e) => {
        if (e.button !== Qt.LeftButton) return;
        const target = drag.target;
        if (atThreshold) {
          root.del();
        } else {
          target.x = 0;
        }
      }
    }
  }
}
