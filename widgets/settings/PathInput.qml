import qs.components
import QtQuick;
import QtQuick.Dialogs;

OptionInput {
  id: root;

  width: parent.width;

  property list<string> dialogNameFilters: [];

  function showDialog() {
    const isVideo = root.controller.getVal("desktop", "videoWallpaper");
    if (isVideo) {
      dialogNameFilters = ["Video files (*.mp4)"];
    } else {
      dialogNameFilters = ["Image files (*.png *.jpg *.jpeg *.svg)"];
    }
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

