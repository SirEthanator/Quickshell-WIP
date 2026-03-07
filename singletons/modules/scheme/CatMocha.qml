import QtQuick;
Scheme {
  title: "Catppuccin Mocha";

  accent: "#B4BEFE";
  accentLight: lighten(accent, 5.0);
  fg: "#CDD6F4";
  bg: "#1E1E2E";
  bgLight: "#313244";
  bgHover: "#45475A";
  bgAccent: "#3F4359";
  bgRed: "#7A4654";
  bgWarning: lighten(warning, -60.0);
  outline: bgAccent;
  grey: "#6C7086";
  greyDim: "#585B70";
  wsInactive: bgHover;
  red: "#F38BA8";
  warning: "#F9E2AF";
  redHover: lighten(red, 5.0);
  redPress: lighten(red, -5.0);

  workspaces: accent;
  activeWindow: "#89B4FA";
  dateAndTime: "#F9E2AF";
  volume: "#FAB387";
  network: "#CBA6F7";
  media: "#94E2D5";

  battery: "#A6E3A1";
  batteryCharging: "#A6E3A1";
  batteryMed: "#F9E2AF";
  batteryLow: red;
}
