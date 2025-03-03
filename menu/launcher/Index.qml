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

  ScrollView {
    anchors.fill: parent;
    clip: true;

    ListView {
      anchors.fill: parent;
      spacing: Globals.vars.marginModule;

      model: ScriptModel {
        values: DesktopEntries.applications.values
        .map(entry => entry)
        .filter(entry => root.searchText.length === 0 || entry.name.toLowerCase().includes(root.searchText.toLowerCase()))
        .sort((a, b) => a.name.localeCompare(b.name))  // Alphabetical order
      }

      delegate: MouseArea{
        id: entryMouseArea;
        required property DesktopEntry modelData;

        width: parent.width;
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
              color: Globals.colours.fg;
              font: Globals.vars.headingFontSmall;
            }
          }
        }
      }
    }
  }
}

