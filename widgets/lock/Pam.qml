import "root:/";
import Quickshell.Services.Pam;
import Quickshell.Wayland;

PamContext {
  id: root;

  required property WlSessionLock lock;
  property string password;
  property string state;
  property bool stateIsMessage: false;

  function attemptUnlock() {
    if (!active)
      start();
  }

  // responseRequired is set to true on pam.start()
  onResponseRequiredChanged: {
    if (responseRequired) {
      state = "authenticating";
      respond(password);
      password = "";
    }
  }

  onCompleted: result => {
    root.stateIsMessage = false;
    if (result === PamResult.Success) {
      lock.unlock();
    } else if (result === PamResult.Failed) {
      state = "failed"
    } else if (result === PamResult.MaxTries) {
      state = "maxTries"
    } else if (result === PamResult.Error) {
      state = "error"
    }
  }

  onPamMessage: {
    state = message;
    root.stateIsMessage = true;
  }
}

