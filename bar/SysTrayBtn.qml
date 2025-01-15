import "..";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;
import org.kde.kirigami as Kirigami;

BarModule {
  id: root;

  Kirigami.Icon {
    id: icon;
    Layout.alignment: Qt.AlignCenter;

    source: "down-symbolic";
    fallback: "error-symbolic";
    isMask: true;
    color: Opts.colours.fg;
    roundToIconSize: false;
    implicitWidth: Opts.vars.moduleIconSize;
    implicitHeight: Opts.vars.moduleIconSize;
  }

  onClicked: event => {
    console.log('clicked')
  }
}

