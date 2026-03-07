import QtQuick;
import Quickshell;
import Quickshell.Io;

Scheme {
  title: "Material";

  FileView {
    id: materialJson;
    path: Qt.resolvedUrl(Quickshell.shellPath("generated/material.json"));
    blockLoading: true;
    watchChanges: true;

    onFileChanged: {
      reload();
    }
  }

  readonly property var c: JSON.parse(materialJson.text());

  accent: c.primary;
  accentLight: lighten(c.primary, 5.0);
  fg: c.on_surface;
  bg: c.surface;
  bgLight: c.surface_container;
  bgHover: c.surface_container_highest;
  bgAccent: c.primary_container;
  bgRed: c.error_container;
  bgWarning: lighten(c.yellow, -45.0)
  outline: c.outline_variant;
  grey: lighten(c.on_surface, -35.0);
  greyDim: lighten(c.on_surface, -55.0);
  wsInactive: c.surface_container_highest;
  red: c.error;
  warning: c.yellow;
  redHover: lighten(red, 5.0);
  redPress: lighten(red, -5.0);

  workspaces: accent;
  activeWindow: c.secondary;
  dateAndTime: c.tertiary;
  volume: c.primary;
  network: c.secondary;
  media: c.tertiary;

  battery: c.primary;
  batteryCharging: c.primary;
  batteryMed: c.yellow;
  batteryLow: c.error;
}
