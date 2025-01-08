pragma Singleton

import Quickshell
import QtQuick

Singleton {
/*   ____  ___  ______________  _  ______
    / __ \/ _ \/_  __/  _/ __ \/ |/ / __/
   / /_/ / ___/ / / _/ // /_/ /    /\ \
   \____/_/    /_/ /___/\____/_/|_/___/ */

  readonly property alias colours: everforest

/*  _   _____   ___  _______   ___  __   ________
   | | / / _ | / _ \/  _/ _ | / _ )/ /  / __/ __/
   | |/ / __ |/ , _// // __ |/ _  / /__/ _/_\ \
   |___/_/ |_/_/|_/___/_/ |_/____/____/___/___/ */

  readonly property var vars: QtObject {
    id: vars

    readonly property int gap: 10;  // Size of Hyprland gap
    readonly property int gapLarge: vars.gap + 8;

    readonly property int br: 6;  // Border Radius

    readonly property int fontMain: 16;

    readonly property int barHeight: 45;
    readonly property int paddingBar: 6;
    // Note that paddingModule will not affect the top and bottom padding. The top and bottom padding is based on the bar's height.
    // Multiplying by two adds padding for both sides since this value is added to implicit width.
    readonly property int paddingModule: 15 * 2;
  }

/*    ___________ ________  ___________
     / __/ ___/ // / __/  |/  / __/ __/
    _\ \/ /__/ _  / _// /|_/ / _/_\ \
   /___/\___/_//_/___/_/  /_/___/___/ */

  readonly property var everforest: QtObject {
    id: everforest

    readonly property color accent: "#A7C080";
    readonly property color accentLight: Qt.lighter(everforest.accent, 1.1);
    readonly property color fg: "#D3C6AA";
    readonly property color bg: "#272E33";
    readonly property color bgLight: "#2E383C";
    readonly property color bgHover: "#414B50";
    readonly property color bgAccent: "#3C4841";
    readonly property color grey: "#7A8478";
    readonly property color wsInactive: everforest.bgHover;
    readonly property color red: "#E67E80";
    readonly property color shadow: "#231E2326"  // 35% opacity
  }

  readonly property var catMocha: QtObject {
    id: catMocha

    readonly property color accent: "#B4BEFE";
    readonly property color accentLight: Qt.lighter(catMocha.accent, 1.1);
    readonly property color fg: "#cdd6f4";
    readonly property color bg: "#1E1E2E";
    readonly property color bgLight: "#313244";
    readonly property color bgHover: "#45475a";
    readonly property color bgAccent: "#5A5F7F";
    readonly property color grey: "#585b70";
    readonly property color wsInactive: catMocha.bgHover;
    readonly property color red: "#F38BA8";
    readonly property color shadow: "#2311111B"  // 35% opacity
  }
}

