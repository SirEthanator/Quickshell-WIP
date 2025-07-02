import "root:/";
import Quickshell.Services.Pam;
import Quickshell.Wayland;

PamContext {
  id: root;

  required property WlSessionLock lock;
  required property WlSessionLockSurface surface;
  property string password;
  property string state;

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
    if (result === PamResult.Success) {
      surface.beginUnlock();
    } else if (result === PamResult.Failed) {
      state = "failed"
    } else if (result === PamResult.MaxTries) {
      state = "maxTries"
    } else if (result === PamResult.Error) {
      state = "error"
    }
  }
}

