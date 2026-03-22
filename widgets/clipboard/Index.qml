pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.widgets.clipboard
import qs.animations as Anims
import QtQuick;
import QtQuick.Controls;
import QtQuick.Layouts;

Item {
  id: root;

  focus: true;
  anchors.fill: parent;

  Keys.onPressed: (e) => {
    if (listView.model.count < 1) return;

    if (e.key === Qt.Key_Up) {
      Controller.up();
    } else if (e.key === Qt.Key_Down) {
      Controller.down();
    } else if (e.key === Qt.Key_Enter || e.key === Qt.Key_Return) {
      Controller.select(Controller.currentIndex);
    }
  }

  Component.onCompleted: Controller.updateModel();

  ColumnLayout {
    id: emptyContent;
    anchors.centerIn: parent;

    spacing: Consts.paddingWindow;
    visible: Controller.model.count < 1;

    Icon {
      icon: "clipboard-outline-symbolic";
      color: Colors.c.grey;
      size: Consts.extraLargeIconSize;
      Layout.alignment: Qt.AlignHCenter;
    }

    Text {
      text: "Clipboard empty";
      color: Colors.c.grey;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.smallHeadingFontSize;
      }
      Layout.fillWidth: true;
      horizontalAlignment: Text.AlignHCenter;
    }
  }

  MouseArea {
    id: listMouse;
    hoverEnabled: true;
    anchors.fill: parent;

    ListView {
      id: listView;
      anchors.fill: parent;

      model: Controller.model;
      currentIndex: Controller.currentIndex;
      highlightMoveDuration: 300;
      highlightMoveVelocity: 0.8;

      spacing: Consts.marginModule;

      visible: model.count > 0;

      flickableDirection: Flickable.VerticalFlick;
      ScrollBar.vertical: StyledScrollBar { scrollView: listView }

      // For scrollbar
      readonly property alias hovered: listMouse.containsMouse;

      displaced: Transition {
        Anims.NumberAnim { property: "y" }
      }
      move: displaced;

      delegate: Item {
        id: listItem;
        required property string value;
        required property int index;

        readonly property bool isCurrent: index === Controller.currentIndex;

        height: itemText.implicitHeight + Consts.paddingCard * 2;
        width: parent.width;

        function del() {
          deleteAnim.restart();
        }

        Item {
          id: container;
          clip: true;

          height: parent.height;
          width: parent.width;
        }

        Item {
          id: itemBackground;

          // Just to avoid more nesting
          parent: container;

          height: parent.height;
          width: parent.width;

          x: 0;

          Anims.NumberTransition on x {}

          SequentialAnimation {
            id: deleteAnim;

            Anims.NumberAnim {
              target: itemBackground;
              property: "x";
              to: itemBackground.width * (itemBackground.x > 0 ? 1 : -1);
            }

            PauseAnimation { duration: 100 }

            ScriptAction {
              script: Controller.del(listItem.index);
            }
          }

          OutlinedRectangle {
            id: itemMainBackground;
            color: itemMouse.drag.active
              ? Colors.c.bgLight
              : itemMouse.containsPress
                ? Colors.c.accent
                : itemMouse.containsMouse || listItem.isCurrent
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
              text: listItem.value.replace(/^\d+\s+/, "");

              anchors {
                verticalCenter: parent.verticalCenter;
                left: parent.left;
                right: parent.right;
                margins: Consts.paddingCard;
              }

              color: !itemMouse.drag.active && itemMouse.containsPress ? Colors.c.bgLight : Colors.c.fg;
              font {
                family: Consts.fontFamily;
                pixelSize: Consts.mainFontSize;
              }

              maximumLineCount: 1;
              clip: true;
            }
          }

          OutlinedRectangle {
            id: itemDeleteBackground;

            color: itemMouse.atThreshold ? Colors.c.red : Colors.c.bgRed;
            disableAllOutlines: itemMainBackground.disableAllOutlines;
            radius: itemMainBackground.radius;

            height: parent.height;
            width: parent.width;

            x: parent.x > 0 ? -width : width;

            Anims.ColorTransition on color {}
            Anims.NumberTransition on radius {}

            Icon {
              icon: "delete-symbolic";
              color: itemMouse.atThreshold ? Colors.c.bgRed : Colors.c.red;
              size: Consts.mainIconSize;

              Anims.ColorTransition on color {}

              x: parent.x < 0 ? parent.width - size - Consts.paddingCard : Consts.paddingCard;

              anchors {
                verticalCenter: parent.verticalCenter;
              }
            }
          }
        }

        MouseArea {
          id: itemMouse
          anchors.fill: parent;
          hoverEnabled: true;

          onClicked: Controller.select(parent.index);

          readonly property real deleteThreshold: 0.25;
          readonly property bool atThreshold: Math.abs(drag.target.x) >= drag.target.width * deleteThreshold;

          drag {
            target: itemBackground;
            axis: Drag.XAxis;
            maximumX: drag.target.width;
            minimumX: -drag.target.width;
            threshold: 15;
          }

          onReleased: (e) => {
            if (e.button !== Qt.LeftButton) return;
            const target = drag.target;
            if (atThreshold) {
              listItem.del();
            } else {
              target.x = 0;
            }
          }
        }
      }
    }
  }
}
