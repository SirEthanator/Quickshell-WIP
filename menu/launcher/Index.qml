pragma ComponentBehavior: Bound

import "root:/";
import "root:/components";
import "root:/animations" as Anims;
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

  ListView {
    id: listView;
    anchors.fill: parent;
    spacing: Globals.vars.marginModule;
    clip: true;

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
      NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Globals.vars.transitionLen }
    }
    move: Transition {
      NumberAnimation { property: "y"; duration: Globals.vars.transitionLen; easing.type: Easing.OutCubic }
      NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Globals.vars.transitionLen }
    }
    remove: Transition {
      NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Globals.vars.shortTransitionLen }
    }

    model: ScriptModel {
      id: model;
      values: DesktopEntries.applications.values
        .filter(entry => root.searchText.length === 0 || entry.name.toLowerCase().includes(root.searchText.toLowerCase()))
        .sort((a, b) => a.name.localeCompare(b.name));  // Alphabetical order
      onValuesChanged: root.currentIndex = 0;
    }

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
        id: entryBg;
        anchors.fill: parent;
        color: entryMouseArea.containsPress
          ? Globals.colours.accent
          : entryMouseArea.containsMouse || entryMouseArea.index === root.currentIndex
            ? Globals.colours.bgHover
            : Globals.colours.bgLight;
        radius: Globals.vars.br;

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
            text: modelData.name;
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

