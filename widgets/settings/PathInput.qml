import qs.components
import QtQuick;
import QtQuick.Dialogs;

OptionInput {
  id: root;

  width: parent.width;

  Button {
    label: "Browse...";
    radiusValue: root.content.topLeftRadius;
    allRadius: true;

    onClicked: dialog.open();
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

    nameFilters: {
      const isVideo = root.controller.getVal("desktop", "videoWallpaper");
      if (isVideo) return ["Video files (*.mp4)"];
      else return ["Image files (*.png *.jpg *.jpeg *.svg)"];
    }

    onAccepted: root.field.text = selectedFile;
  }
}

