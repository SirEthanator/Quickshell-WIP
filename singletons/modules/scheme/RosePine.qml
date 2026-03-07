import QtQuick;
Scheme {
  title: "Rose Pine";

  accent: "#9CCFD8";
  accentLight: lighten(accent, 5.0);
  fg: "#E0DEF4";
  bg: "#1F1D2E";
  bgLight: "#26233A";
  bgHover: "#403D52";
  bgAccent: "#37484C";
  bgRed: "#763849";
  bgWarning: lighten(warning, -55.0);
  outline: bgAccent;
  grey: "#6E6A86";
  greyDim: "#58556B";
  wsInactive: bgHover;
  red: "#EB6F92";
  warning: "#F6C177";
  redHover: lighten(red, 5.0);
  redPress: lighten(red, -5.0);

  workspaces: accent;
  activeWindow: "#31748F";
  dateAndTime: "#F6C177";
  volume: "#C4A7E7";
  network: "#EBBCBA";
  media: "#EB6F92";

  battery: "#31748F";
  batteryCharging: "#31748F";
  batteryMed: "#F6C177";
  batteryLow: red;
}
