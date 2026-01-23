import qs.components
import qs.widgets.settings // For LSP
import QtQuick;
import QtQuick.Dialogs;

// TODO: Path validation

OptionInput {
  id: root;

  width: parent.width;

  property var metadata;
  property list<string> dialogNameFilters: [];

  function showDialog() {
    if (typeof root.metadata.getFileTypes !== "function") {
      dialogNameFilters = ["All files (*)"];
      dialog.open();
      return;
    }

    dialogNameFilters = root.metadata.getFileTypes();
    if (dialogNameFilters === "Directories") {
      folderDialog.open();
    } else {
      dialog.open();
    }
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
    fileMode: FileDialog.OpenFile;

    options: FileDialog.ReadOnly;
    modality: Qt.ApplicationModal;

    nameFilters: root.dialogNameFilters;

    onAccepted: root.field.text = selectedFile;
  }

  FolderDialog {
    id: folderDialog;

    options: FolderDialog.ReadOnly;
    modality: Qt.ApplicationModal;

    onAccepted: root.field.text = selectedFolder;
  }
}

