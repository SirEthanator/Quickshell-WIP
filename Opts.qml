pragma Singleton

import Quickshell
import QtQuick

Singleton {
/*   ____  ___  ______________  _  ______
    / __ \/ _ \/_  __/  _/ __ \/ |/ / __/
   / /_/ / ___/ / / _/ // /_/ /    /\ \
   \____/_/    /_/ /___/\____/_/|_/___/  */

  // Global
  readonly property alias colours: everforest;

  // Bar
  readonly property var bar: QtObject {
    property bool docked: false;  // Controls if the bar floats or is docked | false
    property bool floatingModules: false;  // Controls if the bar has a visible background | false
    property bool multiColourModules: false;  // Controls if modules should use different colours or the accent colour | false
    property int workspaceCount: 10;  // Controls how many workspaces are displayed in the workspace widget | 10
    property int truncationLength: 100;  // Controls the maximum length of modules with long text | 100
  }

/*  _   _____   ___  _______   ___  __   ________
   | | / / _ | / _ \/  _/ _ | / _ )/ /  / __/ __/
   | |/ / __ |/ , _// // __ |/ _  / /__/ _/_\ \
   |___/_/ |_/_/|_/___/_/ |_/____/____/___/___/  */

  readonly property var vars: QtObject {
    id: vars

    property int gap: 10;  // Size of Hyprland gap
    property int gapLarge: vars.gap + 8;

    property int br: 6;  // Border Radius

    property font mainFont: Qt.font({
      family: "Cascadia Code",
      pixelSize: 16,
      kerning: false
    })

    property font nerdFont: Qt.font({
      family: "Symbols Nerd Font Mono",
      pixelSize: vars.moduleIconSize,
      kerning: false
    })

    property int barHeight: vars.moduleIconSize + vars.paddingModule + vars.paddingBar*2;  // This results in the modules' top and bottom padding matching paddingModule - relies on icons being the tallest items
    property int paddingBar: 6;
    // Note that paddingModule will not affect the top and bottom padding. The top and bottom padding is based on the bar's height.
    property int paddingModule: 8;
    property int marginModule: 8;
    property int moduleIconSize: 22;
    property int wsSize: 7;
  }

/*    ___________ ________  ___________
     / __/ ___/ // / __/  |/  / __/ __/
    _\ \/ /__/ _  / _// /|_/ / _/_\ \
   /___/\___/_//_/___/_/  /_/___/___/  */

  readonly property var everforest: QtObject {
    id: everforest

    property color accent: "#A7C080";
    property color accentLight: Qt.lighter(everforest.accent, 1.1);
    property color fg: "#D3C6AA";
    property color bg: "#272E33";
    property color bgLight: "#2E383C";
    property color bgHover: "#414B50";
    property color bgAccent: "#3C4841";
    property color grey: "#7A8478";
    property color wsInactive: everforest.bgHover;
    property color red: "#E67E80";
    property color shadow: "#231E2326";  // 35% opacity

    property color activeWindow: "#7FBBB3";
    property color dateAndTime: "#DBBC7F";
    property color volume: "#83C092";
  }

  readonly property var catMocha: QtObject {
    id: catMocha

    property color accent: "#B4BEFE";
    property color accentLight: Qt.lighter(catMocha.accent, 1.1);
    property color fg: "#cdd6f4";
    property color bg: "#1E1E2E";
    property color bgLight: "#313244";
    property color bgHover: "#45475a";
    property color bgAccent: "#5A5F7F";
    property color grey: "#585b70";
    property color wsInactive: catMocha.bgHover;
    property color red: "#F38BA8";
    property color shadow: "#2311111B";  // 35% opacity

    property color activeWindow: "#89b4fa";
    property color dateAndTime: "#f9e2af";
    property color volume: "#94e2d5";
  }
}

