pragma Singleton

import "utils" as Utils;
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  /*   ____  ___  ______________  _  ______
      / __ \/ _ \/_  __/  _/ __ \/ |/ / __/
     / /_/ / ___/ / / _/ // /_/ /    /\ \
     \____/_/    /_/ /___/\____/_/|_/___/   */

  // -- ----- --
  FileView {
    id: confFile;
    path: Qt.resolvedUrl("./config.json");
    blockLoading: true;
  }

  FileView {
    id: defaultConfFile;
    path: Qt.resolvedUrl("./defaultConf.json");
    blockLoading: true;
  }

  function deepMerge(defaultOptions, userOptions) {
    Object.entries(userOptions).forEach(([key, value]) => {
      if (value && typeof value === 'object') deepMerge(defaultOptions[key] = defaultOptions[key] || [], value)
      else defaultOptions[key] = value;
    });
    return defaultOptions
  }

  readonly property var defaultConf: JSON.parse(defaultConfFile.text());
  readonly property var userConf: JSON.parse(confFile.text());
  readonly property var conf: deepMerge(defaultConf, userConf);

  // -- Global --
  readonly property QtObject colours: schemes[conf.colourScheme];

  Component.onCompleted: {
    if (colours === null) {
      console.log(`Invalid colour scheme: ${conf.colourScheme}`);
      Qt.callLater(Qt.quit);
    }
  }

  /*  _   _____   ___  _______   ___  __   ________
     | | / / _ | / _ \/  _/ _ | / _ )/ /  / __/ __/
     | |/ / __ |/ , _// // __ |/ _  / /__/ _/_\ \
     |___/_/ |_/_/|_/___/_/ |_/____/____/___/___/   */

  readonly property QtObject vars: QtObject {
    id: vars

    property int gap: Utils.SysInfo.gap;  // Size of Hyprland gap
    property int gapLarge: vars.gap + 8;

    property int br: 6;  // Border Radius

    property real outlineSize: 1.5;

    property real shadowBlur: 3;
    property real shadowOpacity: 0.9;

    property string fontFamily: "0xProto";
    property int mainFontSize: 16;
    property int xlFontSize: 150;
    property int headingFontSize: 34;
    property int smallHeadingFontSize: 22;

    property font nerdFont: ({
      family: "Symbols Nerd Font Mono",
      pixelSize: vars.moduleIconSize
    });

    property int barHeight: vars.moduleIconSize + vars.paddingModule + vars.paddingBar*2;  // This results in the modules' top and bottom padding matching paddingModule - relies on icons being the tallest items
    property int paddingBar: 6;
    // Note that paddingModule will not directly affect the top and bottom padding. The top and bottom padding is based on the bar's height.
    property int paddingModule: 8;
    property int marginModule: 8;
    property int moduleIconSize: 22;
    property int wsSize: 7;

    property int paddingWindow: 24;

    property int paddingCard: 20;
    property int marginCardSmall: 6;
    property int marginCard: 10;

    property int paddingButton: 8;
    property int spacingButtonGroup: 3;

    property int animLen: 350;
    property int transitionLen: 250;
    property int shortTransitionLen: 150;

    property int clockWidgetSpacing: 8;
    property int clockWidgetTopMargin: 100;
  }

  /*    ___________ ________  ___________
       / __/ ___/ // / __/  |/  / __/ __/
      _\ \/ /__/ _  / _// /|_/ / _/_\ \
     /___/\___/_//_/___/_/  /_/___/___/   */

  readonly property var schemes: ({ everforest: everforest, catMocha: catMocha, rosePine: rosePine });

  readonly property QtObject everforest: QtObject {
    id: everforest

    property color accent: "#A7C080";
    property color accentDark: Qt.darker(accent, 1.2);
    property color accentLight: Qt.lighter(accent, 1.2);
    property color fg: "#D3C6AA";
    property color bg: "#272E33";
    property color bgLight: "#2E383C";
    property color bgHover: "#414B50";
    property color bgAccent: "#3C4841";
    property color outline: bgAccent;
    property color grey: "#7A8478";
    property color wsInactive: bgHover;
    property color red: "#E67E80";
    property color shadow: "#1E2326";

    property color workspaces: accent;
    property color activeWindow: "#7FBBB3";
    property color dateAndTime: "#DBBC7F";
    property color volume: "#E69875";

    property color battery: "#A7C080";
    property color batteryCharging: "#A7C080";
    property color batteryMed: "#DBBC7F";
    property color batteryLow: red;
  }

  readonly property QtObject catMocha: QtObject {
    id: catMocha

    property color accent: "#B4BEFE";
    property color accentDark: Qt.darker(accent, 1.2);
    property color accentLight: Qt.lighter(accent, 1.2);
    property color fg: "#CDD6F4";
    property color bg: "#1E1E2E";
    property color bgLight: "#313244";
    property color bgHover: "#45475A";
    property color bgAccent: "#5A5F7F";
    property color outline: bgAccent;
    property color grey: "#585B70";
    property color wsInactive: bgHover;
    property color red: "#F38BA8";
    property color shadow: "#11111B";

    property color workspaces: accent;
    property color activeWindow: "#89b4fa";
    property color dateAndTime: "#F9E2AF";
    property color volume: "#FAB387";

    property color battery: "#A6E3A1";
    property color batteryCharging: "#A6E3A1";
    property color batteryMed: "#f9e2af";
    property color batteryLow: red;
  }

  readonly property QtObject rosePine: QtObject {
    id: rosePine

    property color accent: "#9CCFD8";
    property color accentDark: Qt.darker(accent, 1.2);
    property color accentLight: Qt.lighter(accent, 1.2);
    property color fg: "#E0DEF4";
    property color bg: "#1F1D2E";
    property color bgLight: "#26233A";
    property color bgHover: "#403D52";
    property color bgAccent: "#4E686C";
    property color outline: bgAccent;
    property color grey: "#6E6A86";
    property color wsInactive: bgHover;
    property color red: "#EB6F92";
    property color shadow: "#191724";

    property color workspaces: accent;
    property color activeWindow: "#31748F";
    property color dateAndTime: "#F6C177";
    property color volume: "#C4A7E7";

    property color battery: "#31748F";
    property color batteryCharging: "#31748F";
    property color batteryMed: "#F6C177";
    property color batteryLow: red;
  }

  /*    _____________ ______________
       / __/_  __/ _ /_  __/ __/ __/
      _\ \  / / / __ |/ / / _/_\ \
     /___/ /_/ /_/ |_/_/ /___/___/   */

  property QtObject states: QtObject {
    id: states

    property bool menuOpen: false;
    property bool barHidden: false;
    property bool screensaverActive: false;
  }
}

