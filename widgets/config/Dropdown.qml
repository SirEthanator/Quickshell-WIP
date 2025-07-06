pragma ComponentBehavior: Bound

import "root:/";
import "root:/components";
import QtQuick;
import QtQuick.Controls;

ComboBox {
  id: root;
  required property var controller;
  required property var options;
  required property string page;
  required property string propName;

  property bool completed;
  Component.onCompleted: completed = true;

  model: {
    let result = [];
    for (const key in options) {
      result.push(Object.assign({ key: key }, options[key]));
    }
    return result;
  }
  textRole: "title";

  delegate: Button {
    required property var modelData;
    required property int index;

    label: modelData.title;
    autoWidth: true;
    autoHeight: true;
    onClicked: {
      root.currentIndex = index;
      root.popup.close();
    }
  }

  onCurrentIndexChanged: {
    if (completed) {
      console.log(model[currentIndex].key);
      controller.changeVal(page, propName, model[currentIndex].key);
    }
  }
}

