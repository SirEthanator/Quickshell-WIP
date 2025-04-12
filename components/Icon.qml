import "root:/";
import org.kde.kirigami as Kirigami;
import QtQuick;

Kirigami.Icon {
  required property string icon;
  property color colour;
  property real size: Globals.vars.moduleIconSize;

  source: icon;
  fallback: "warning-outline-symbolic";
  isMask: true;  // Allows us to change the icon's colour. It replaces all non-transparent colours with ours.
  color: colour;
  roundToIconSize: false;  // Improves scaling for non-standard icon sizes
  implicitWidth: size;
  implicitHeight: size;
}

