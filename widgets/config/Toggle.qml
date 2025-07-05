import "root:/";
import QtQuick;
import QtQuick.Controls;

Switch {
  id: root;

  required property Config page;
  required property string propName;

  checked: page[propName];
  onCheckedChanged: {
    page[propName] = checked
  }
}

