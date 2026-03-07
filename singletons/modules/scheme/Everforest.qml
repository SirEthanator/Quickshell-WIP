import QtQuick;
Scheme {
  title: "Everforest";

  accent: "#A7C080";
  accentLight: lighten(accent, 7.0);
  fg: "#D3C6AA";
  bg: "#272E33";
  bgLight: "#2E383C";
  bgHover: "#414B50";
  bgAccent: "#3C4841";
  bgRed: "#4C3743";
  bgWarning: "#45443C";
  outline: bgAccent;
  grey: "#7A8478";
  greyDim: "#4F5B58";
  wsInactive: bgHover;
  red: "#E67E80";
  warning: "#DBBC7F";
  redHover: lighten(red, 5.0);
  redPress: lighten(red, -5.0);

  workspaces: accent;
  activeWindow: "#7FBBB3";
  dateAndTime: "#DBBC7F";
  volume: "#E69875";
  network: "#D699B6";
  media: "#83C092";

  battery: "#A7C080";
  batteryCharging: "#A7C080";
  batteryMed: "#DBBC7F";
  batteryLow: red;
}
