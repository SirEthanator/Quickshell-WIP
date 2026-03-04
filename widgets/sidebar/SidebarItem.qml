import qs.widgets.sidebar
import QtQuick;

Loader {
  required sourceComponent;
  required property string identifier;
  active: Controller.active.includes(identifier) || Controller.finalActive === identifier;
}
