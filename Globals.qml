pragma Singleton

import "components";
import "utils" as Utils;
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;

  // ===================
  // ==== Variables ====
  // ===================

  readonly property var vars: QtObject {
    id: vars

    property var barModules: ({
      workspaces: {
        title: "Workspaces",
        url: "Workspaces.qml",
        props: ["screen"]
      },
      tray: {
        title: "System Tray",
        url: "SysTray.qml",
        props: ["window"]
      },
      menu: {
        title: "Menu Button",
        url: "MenuBtn.qml",
      },
      activeWindow: {
        title: "Active Window",
        url: "ActiveWindow.qml"
      },
      dateAndTime: {
        title: "Date & Time",
        url: "DateAndTime.qml"
      },
      network: {
        title: "Network",
        url: "Network.qml"
      },
      battery: {
        title: "Battery",
        url: "Battery.qml"
      },
      media: {
        title: "Media",
        url: "Media.qml"
      },
      volume: {
        title: "Volume",
        url: "Volume.qml"
      }
    });

    property var dashModules: ({
      userInfo: {
        title: "User Info & Power",
        url: "userinfo/Index.qml"
      },
      sysStats: {
        title: "System Stats",
        url: "sysstats/Index.qml"
      },
      notifCentre: {
        title: "Notification Centre",
        url: "NotifCentre.qml"
      },
      tray: {
        title: "System Tray",
        url: "SysTray.qml"
      }
    });

    property int gap: Utils.Session.gap;  // Size of Hyprland/niri gap
    property int gapLarge: vars.gap + 8;

    property int br: 6;  // Border Radius
    property int brSmall: 2;

    property real outlineSize: 1.5;

    property string fontFamily: "Roboto Flex";
    property int mainFontSize: 16;
    property int largeFontSize: 64;
    property int xlFontSize: 150;
    property int headingFontSize: 34;
    property int smallHeadingFontSize: 22;
    property int mediumHeadingFontSize: 28;

    // This results in the modules' top and bottom padding matching paddingModule / 2 - relies on icons being the tallest items
    // Changes due to configuration are handled in Bar/Index
    property int barHeight: vars.moduleIconSize + vars.paddingModule + vars.paddingBar*2 + vars.outlineSize*2;
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

    property int paddingButton: 10;
    property int paddingButtonIcon: 8;
    property int spacingButtonGroup: 3;

    property int longAnimLen: 500;
    property int animLen: 350;
    property int transitionLen: 250;
    property int shortTransitionLen: 150;

    property int notifPopupSpacing: 10;
    property int paddingNotif: paddingCard;
    property int notifInnerSpacing: 10;

    property int mainIconSize: 28;
    property int largeIconSize: 34;
    property int extraLargeIconSize: 90;

    property color bgDimmedColour: "#4D000000";
    property real disabledOpacity: 0.5;
  }

  // =================
  // ==== Schemes ====
  // =================

  readonly property Scheme colours: schemes[Conf.global.colourScheme];

  readonly property var schemes: ({ everforest: everforest, catMocha: catMocha, rosePine: rosePine, material: material });

  readonly property Scheme everforest: Scheme {
    id: everforest

    title: "Everforest";

    accent: "#A7C080";
    accentDark: Qt.darker(accent, 1.2);
    accentLight: Qt.lighter(accent, 1.2);
    fg: "#D3C6AA";
    bg: "#272E33";
    bgLight: "#2E383C";
    bgHover: "#414B50";
    bgAccent: "#3C4841";
    bgRed: "#4C3743";
    outline: bgAccent;
    grey: "#7A8478";
    wsInactive: bgHover;
    red: "#E67E80";
    warning: "#DBBC7F";
    redHover: Qt.lighter(red, 1.2);
    redPress: Qt.darker(red, 1.2);

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

  readonly property Scheme catMocha: Scheme {
    id: catMocha

    title: "Catppuccin Mocha";

    accent: "#B4BEFE";
    accentDark: Qt.darker(accent, 1.2);
    accentLight: Qt.lighter(accent, 1.2);
    fg: "#CDD6F4";
    bg: "#1E1E2E";
    bgLight: "#313244";
    bgHover: "#45475A";
    bgAccent: "#3F4359";
    bgRed: "#7A4654";
    outline: bgAccent;
    grey: "#6C7086";
    wsInactive: bgHover;
    red: "#F38BA8";
    warning: "#F9E2AF";
    redHover: Qt.lighter(red, 1.2);
    redPress: Qt.darker(red, 1.2);

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

  readonly property Scheme rosePine: Scheme {
    id: rosePine

    title: "Rose Pine";

    accent: "#9CCFD8";
    accentDark: Qt.darker(accent, 1.2);
    accentLight: Qt.lighter(accent, 1.2);
    fg: "#E0DEF4";
    bg: "#1F1D2E";
    bgLight: "#26233A";
    bgHover: "#403D52";
    bgAccent: "#37484C";
    bgRed: "#763849";
    outline: bgAccent;
    grey: "#6E6A86";
    wsInactive: bgHover;
    red: "#EB6F92";
    warning: "#F6C177";
    redHover: Qt.lighter(red, 1.2);
    redPress: Qt.darker(red, 1.2);

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

  FileView {
    id: materialJson;
    path: Qt.resolvedUrl("./utils/material.json");
    blockLoading: true;
    watchChanges: true;

    function setLoaderSrc() {
      materialSchemeLoader.setSource("components/Scheme.qml", JSON.parse(text()));
    }

    Component.onCompleted: setLoaderSrc();
    onFileChanged: {
      reload();
      waitForJob();
      setLoaderSrc();
    }
  }

  Loader {
    id: materialSchemeLoader;
  }

  readonly property Scheme material: {
    if (materialSchemeLoader.status === Loader.Error || materialSchemeLoader.item === null) {
      return everforest  // Use Everforest as a fallback
    }
    return materialSchemeLoader.item as Scheme;
  }

  function alpha(color: color, opacity: real): color {
    return Qt.rgba(color.r, color.b, color.g, opacity)
  }

  // ================
  // ==== States ====
  // ================

  signal launchConfMenu;

  PersistentProperties {
    id: persist

    property bool menuOpen: false;
    property bool barHidden: false;
    property bool screensaverActive: false;
  }

  property alias states: persist;
}

