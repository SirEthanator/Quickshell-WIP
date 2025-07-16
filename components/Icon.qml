import qs
import qs.animations as Anims;
import org.kde.kirigami as Kirigami;
import QtQuick;

Kirigami.Icon {
  id: root;
  required property string icon;
  property color colour;
  property real size: Globals.vars.moduleIconSize;
  property int rotation;

  source: icon;
  fallback: "warning-outline-symbolic";
  isMask: true;  // Allows us to change the icon's colour. It replaces all non-transparent colours with ours.
  color: colour;
  roundToIconSize: false;  // Improves scaling for non-standard icon sizes
  implicitWidth: size;
  implicitHeight: size;

  transform: Rotation {
    origin.x: root.size/2; origin.y: root.size/2;
    angle: root.rotation ?? 0;
    Anims.NumberTransition on angle {}
  }
}

