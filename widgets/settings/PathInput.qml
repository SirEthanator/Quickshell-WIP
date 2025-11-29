import qs.components
import QtQuick;
import QtQuick.Dialogs;

OptionInput {
  id: root;

  width: parent.width;

  property var metadata;
  property list<string> dialogNameFilters: [];

  function showDialog() {
    if (typeof root.metadata.getFileTypes !== "function") {
      root.dialogNameFilters = ["All files (*)"];
      return
    }

    dialogNameFilters = root.metadata.getFileTypes(root.controller.getVal);
    dialog.open();
  }

  Button {
    label: "Browse...";
    radiusValue: root.content.topLeftRadius;
    allRadius: true;

    onClicked: root.showDialog();
  }

  rightPadding: false;
  topPadding: false;
  bottomPadding: false;

  FileDialog {
    id: dialog;
    acceptLabel: "Select";
    rejectLabel: "Cancel";
    fileMode: FileDialog.OpenFile;

    options: FileDialog.ReadOnly;
    modality: Qt.ApplicationModal;

    nameFilters: root.dialogNameFilters;

    onAccepted: root.field.text = selectedFile;
  }
}

