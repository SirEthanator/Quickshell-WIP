pragma Singleton

import Quickshell;
import Quickshell.Networking;

Singleton {
  id: root;

  readonly property ObjectModel devices: Networking.devices;
  readonly property WifiDevice trackedDevice: devices.values[0];

  readonly property ObjectModel networks: trackedDevice.networks;
  readonly property WifiNetwork connectedNetwork: networks.values.filter(n => n.connected)[0] ?? null;
}
