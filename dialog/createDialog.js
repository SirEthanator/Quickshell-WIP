var component;
var dialog;

function createDialog(parent, title, text, actions, screen) {
  component = Qt.createComponent("Index.qml");
  if (component.status == Component.Ready) {
    finishCreation(parent, title, text, actions, screen);
  } else {
    component.statusChanged.connect(() => finishCreation(parent, title, text, actions, screen));
  }
}

function finishCreation(parent, title, text, actions, screen) {
  if (component.status == Component.Ready) {
    dialog = component.createObject(parent, {
      title: title,
      text: text,
      actions: actions,
      screen: screen});

    if (dialog == null) {
      console.log("Error creating object");
    }
  } else if (component.status == Component.Error) {
    console.log("Error loading component:", component.errorString());
  }
}
