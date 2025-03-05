pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import Quickshell;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Controls;
import QtQuick.Layouts;

Item {
  id: root;
  required property string searchText;

  function execTop() {
    model.values[0].execute()
  }

  ListView {
    id: listView;
    anchors.fill: parent;
    spacing: Globals.vars.marginModule;
    clip: true;

    cacheBuffer: 0;

    boundsBehavior: Flickable.StopAtBounds;

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
      .sort((a, b) => a.name.localeCompare(b.name))  // Alphabetical order
    }

    delegate: MouseArea{
      id: entryMouseArea;
      required property DesktopEntry modelData;

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
          : entryMouseArea.containsMouse
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

