pragma Singleton

import Quickshell;
import Quickshell.Networking;

Singleton {
  id: root;

  // TODO: Wired network support

  readonly property ObjectModel devices: Networking.devices;
  readonly property WifiDevice trackedDevice: devices.values.filter(d => d.type === DeviceType.Wifi)[0];

  readonly property ObjectModel networks: trackedDevice.networks;
  readonly property WifiNetwork connectedNetwork: networks.values.filter(n => n.connected)[0] ?? null;
}
