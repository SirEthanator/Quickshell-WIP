pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.utils as Utils;
import qs.animations as Anims;
import Quickshell;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Controls;
import QtQuick.Layouts;

Item {
  id: root;
  required property string searchText;
  property int currentIndex: 0;

  function execSelected() {
    if (model.values.length > 0) {
      model.values[currentIndex].execute();
      Globals.states.menuOpen = false;
    }
  }

  function down() {
    if (currentIndex < model.values.length-1) currentIndex++;
  }

  function up() {
    if (currentIndex > 0) currentIndex--;
  }

  readonly property ScriptModel model: ScriptModel {
    values: Utils.Fuzzy.fuzzySearch(DesktopEntries.applications.values, root.searchText, "name");
    onValuesChanged: root.currentIndex = 0;
  }

  ColumnLayout {
    spacing: Globals.vars.paddingCard;
    opacity: root.model.values.length > 0 ? 0 : 1;
    anchors.centerIn: parent;

    Anims.NumberTransition on opacity {}

    Icon {
      icon: "search-symbolic";
      colour: Globals.colours.grey;
      size: Globals.vars.extraLargeIconSize;
      Layout.alignment: Qt.AlignHCenter;
    }

    Text {
      text: "No Results Found";
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.smallHeadingFontSize;
      }
      color: Globals.colours.grey;
      Layout.fillWidth: true;
      horizontalAlignment: Text.AlignHCenter;
    }
  }

  MouseArea {
    anchors.fill: parent;
    hoverEnabled: true;

    ListView {
      id: listView;
      readonly property bool hovered: parent.containsMouse;

      anchors.fill: parent;
      spacing: Globals.vars.marginModule;
      clip: true;
      opacity: root.model.values.length > 0 ? 1 : 0;

      Anims.NumberTransition on opacity {}

      currentIndex: root.currentIndex;
      highlightMoveDuration: 300;
      highlightMoveVelocity: 0.8;

      flickableDirection: Flickable.VerticalFlick;
      flickDeceleration: 2000;
      boundsBehavior: Flickable.StopAtBounds;
      ScrollBar.vertical: StyledScrollBar { scrollView: listView }

      cacheBuffer: 0;

      add: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Globals.vars.shortTransitionLen }
      }
      displaced: Transition {
        NumberAnimation { property: "y"; duration: Globals.vars.transitionLen; easing.type: Easing.OutCubic }
        PropertyAction { property: "opacity"; value: 1 }
      }
      move: Transition {
        NumberAnimation { property: "y"; duration: Globals.vars.transitionLen; easing.type: Easing.OutCubic }
        PropertyAction { property: "opacity"; value: 1 }
      }
      remove: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Globals.vars.shortTransitionLen }
      }

      model: root.model;
      delegate: MouseArea {
        id: entryMouseArea;
        required property DesktopEntry modelData;
        required property int index;

        width: listView.width;
        height: entryContent.implicitHeight + Globals.vars.paddingButton * 2;

        hoverEnabled: true;

        onClicked: {
          modelData.execute();
          Globals.states.menuOpen = false;
        }

        Rectangle {
          anchors.fill: parent;
          readonly property bool selected: entryMouseArea.containsMouse || entryMouseArea.index === root.currentIndex;
          readonly property bool containsPress: entryMouseArea.containsPress;

          color: containsPress
            ? Globals.colours.accent
            : selected
              ? Globals.colours.bgHover
              : Globals.colours.bgLight;
          radius: Globals.vars.br;

          border {
            color: Globals.conf.menu.moduleOutlines && !selected ? Globals.colours.outline : "transparent";
            width: Globals.conf.menu.moduleOutlines ? Globals.vars.outlineSize : 0;
            pixelAligned: false;
          }

          Anims.ColourTransition on color {}

          RowLayout {
            id: entryContent;
            anchors {
              top: parent.top;
              bottom: parent.bottom;
              left: parent.left;
              margins: Globals.vars.paddingButton;
            }
            spacing: Globals.vars.paddingButton;

            IconImage {
              Layout.alignment: Qt.AlignVCenter;
              asynchronous: true;
              implicitSize: 42;
              source: Quickshell.iconPath(entryMouseArea.modelData.icon);
            }

            Text {
              text: entryMouseArea.modelData.name;
              color: entryMouseArea.containsPress ? Globals.colours.bgLight : Globals.colours.fg;
              font {
                family: Globals.vars.fontFamily;
                pixelSize: Globals.vars.smallHeadingFontSize;
              }
            }
          }
        }
      }
    }
  }
}

