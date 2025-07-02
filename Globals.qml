pragma Singleton

import "utils" as Utils;
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;
  /*   ____  ___  ______________  _  ______
      / __ \/ _ \/_  __/  _/ __ \/ |/ / __/
     / /_/ / ___/ / / _/ // /_/ /    /\ \
     \____/_/    /_/ /___/\____/_/|_/___/   */

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

  function deepMerge(def, user) {
    if (!user) return def;
    Object.entries(user).forEach(([key, value]) => {
      if (value && typeof value === 'object' && !Array.isArray(value)) deepMerge(def[key] = def[key] || [], value)
      else def[key] = value;
    });
    return def
  }

  signal userConfUpdated(reload: bool);
  readonly property var defaultConf: JSON.parse(defaultConfFile.text());
  property var userConf: JSON.parse(confFile.text());
  readonly property var conf: deepMerge(defaultConf, userConf);

  readonly property QtObject colours: schemes[conf.colourScheme];

  function setConf(property: list<string>, value, reload: bool, validate): string {
    const validationResult = (typeof validate === "function") ? validate() : undefined;
    if (validationResult) return validationResult;
    if (!property || property.length === 0) return "";

    let currentObj = userConf;
    let currentDefault = defaultConf;

    // Loop through the property
    for (let i=0; i < property.length; i++) {
      const propName = property[i];

      if (!currentDefault.hasOwnProperty(propName)) {
        console.warn(`setConf: Invalid property: ${property.join(".")}`);
        return "";
      }

      if (i === property.length - 1) {  // Check if final property
        currentObj[propName] = value;
        userConfUpdated(reload);
      } else {
        // If property doesn't exist, create it
        // This does not apply for the final property (e.g. autohide in bar.autohide)
        // This is only used when an entire section does not exist (e.g. bar in bar.autohide)
        if (!currentObj.hasOwnProperty(propName)) currentObj[propName] = {};

        currentObj = currentObj[propName];
        currentDefault = currentDefault[propName];
      }
    }
    return ""
  }

  function setColours(scheme: string, reload: bool): string {
    const validate = () => Utils.Validate.validateObjKey(scheme, schemes, "Failed to set colour scheme");
    return setConf(["colourScheme"], scheme, reload, validate);
  }

  function setWallpaper(path: string, reload: bool): void {
    setConf(['desktop', 'wallpaper'], path, reload);
  }

  function switchTheme(scheme: string): string {
    const validationResult = Utils.Validate.validateObjKey(scheme, schemes, "Failed to set colour scheme");
    if (validationResult) return validationResult;
    states.themeSwitchInProgress = true;
    states.themeOverlayOpen = true;
    setTheme.scheme = scheme;
    setTheme.running = true;
    return "";
  }

  Process {
    id: setTheme;

    property string scheme: "";
    command: ["sh", "-c", `${Quickshell.env("HOME")}/Scripts/SetTheme ${scheme} --noconfirm --noqsreload`];
    stdout: SplitParser {
      onRead: data => root.states.themeSwitchingState = data;
    }
    onExited: {
      // Wait a little while before closing to show complete message
      Utils.Timeout.setTimeout(() => {
        root.states.themeSwitchInProgress = false;
        Quickshell.reload(false);
      }, 1000);
    }
  }

  onUserConfUpdated: (reload) => {
    confFile.setText(JSON.stringify(userConf, null, 2));
    if (reload) Quickshell.reload(false);
  }

  /*  _   _____   ___  _______   ___  __   ________
     | | / / _ | / _ \/  _/ _ | / _ )/ /  / __/ __/
     | |/ / __ |/ , _// // __ |/ _  / /__/ _/_\ \
     |___/_/ |_/_/|_/___/_/ |_/____/____/___/___/   */

  readonly property QtObject vars: QtObject {
    id: vars

    property var barModules: ({
      workspaces: {
        url: "Workspaces.qml",
        props: ["screen"]
      },
      tray: {
        url: "SysTray.qml",
        props: ["window"]
      },
      menu:         { url: "MenuBtn.qml"      },
      activeWindow: { url: "ActiveWindow.qml" },
      dateAndTime:  { url: "DateAndTime.qml"  },
      network:      { url: "Network.qml"      },
      battery:      { url: "Battery.qml"      },
      media:        { url: "Media.qml"        },
      volume:       { url: "Volume.qml"       }
    });

    property var dashModules: ({
      userInfo:    { url: "userinfo/Index.qml" },
      sysStats:    { url: "sysstats/Index.qml" },
      notifCentre: { url: "NotifCentre.qml"    },
      tray:        { url: "SysTray.qml"        }
    });

    property int gap: Utils.SysInfo.gap;  // Size of Hyprland gap
    property int gapLarge: vars.gap + 8;

    property int br: 6;  // Border Radius
    property int brSmall: 2;

    property real outlineSize: 1.5;

    property string fontFamily: "0xProto";
    property int mainFontSize: 16;
    property int largeFontSize: 64;
    property int xlFontSize: 150;
    property int headingFontSize: 34;
    property int smallHeadingFontSize: 22;
    property int mediumHeadingFontSize: 28;

    // This results in the modules' top and bottom padding matching paddingModule - relies on icons being the tallest items
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

    property int animLen: 350;
    property int transitionLen: 250;
    property int shortTransitionLen: 150;

    property int clockWidgetSpacing: 8;
    property int clockWidgetTopMargin: 100;

    property int notifPopupSpacing: 10;
    property int paddingNotif: paddingCard;
    property int notifInnerSpacing: 10;

    property int largeIconSize: 40;
    property int extraLargeIconSize: 90;

    property color bgDimmedColour: "#4D000000";
  }

  /*    ___________ ________  ___________
       / __/ ___/ // / __/  |/  / __/ __/
      _\ \/ /__/ _  / _// /|_/ / _/_\ \
     /___/\___/_//_/___/_/  /_/___/___/   */

  readonly property var schemes: ({ everforest: everforest, catMocha: catMocha, rosePine: rosePine });

  readonly property QtObject everforest: QtObject {
    id: everforest

    property string fullName: "Everforest";

    property color accent: "#A7C080";
    property color accentDark: Qt.darker(accent, 1.2);
    property color accentLight: Qt.lighter(accent, 1.2);
    property color fg: "#D3C6AA";
    property color bg: "#272E33";
    property color bgLight: "#2E383C";
    property color bgHover: "#414B50";
    property color bgAccent: "#3C4841";
    property color bgRed: "#4C3743";
    property color outline: bgAccent;
    property color grey: "#7A8478";
    property color wsInactive: bgHover;
    property color red: "#E67E80";
    property color warning: "#DBBC7F";
    property color redHover: Qt.lighter(red, 1.2);
    property color redPress: Qt.darker(red, 1.2);

    property color workspaces: accent;
    property color activeWindow: "#7FBBB3";
    property color dateAndTime: "#DBBC7F";
    property color volume: "#E69875";
    property color network: "#D699B6";
    property color media: "#83C092";

    property color battery: "#A7C080";
    property color batteryCharging: "#A7C080";
    property color batteryMed: "#DBBC7F";
    property color batteryLow: red;
  }

  readonly property QtObject catMocha: QtObject {
    id: catMocha

    property string fullName: "Catppuccin Mocha";

    property color accent: "#B4BEFE";
    property color accentDark: Qt.darker(accent, 1.2);
    property color accentLight: Qt.lighter(accent, 1.2);
    property color fg: "#CDD6F4";
    property color bg: "#1E1E2E";
    property color bgLight: "#313244";
    property color bgHover: "#45475A";
    property color bgAccent: "#3F4359";
    property color bgRed: "#7A4654";
    property color outline: bgAccent;
    property color grey: "#6C7086";
    property color wsInactive: bgHover;
    property color red: "#F38BA8";
    property color warning: "#F9E2AF";
    property color redHover: Qt.lighter(red, 1.2);
    property color redPress: Qt.darker(red, 1.2);

    property color workspaces: accent;
    property color activeWindow: "#89B4FA";
    property color dateAndTime: "#F9E2AF";
    property color volume: "#FAB387";
    property color network: "#CBA6F7";
    property color media: "#94E2D5";

    property color battery: "#A6E3A1";
    property color batteryCharging: "#A6E3A1";
    property color batteryMed: "#F9E2AF";
    property color batteryLow: red;
  }

  readonly property QtObject rosePine: QtObject {
    id: rosePine

    property string fullName: "Rose Pine";

    property color accent: "#9CCFD8";
    property color accentDark: Qt.darker(accent, 1.2);
    property color accentLight: Qt.lighter(accent, 1.2);
    property color fg: "#E0DEF4";
    property color bg: "#1F1D2E";
    property color bgLight: "#26233A";
    property color bgHover: "#403D52";
    property color bgAccent: "#37484C";
    property color bgRed: "#763849";
    property color outline: bgAccent;
    property color grey: "#6E6A86";
    property color wsInactive: bgHover;
    property color red: "#EB6F92";
    property color warning: "#F6C177";
    property color redHover: Qt.lighter(red, 1.2);
    property color redPress: Qt.darker(red, 1.2);

    property color workspaces: accent;
    property color activeWindow: "#31748F";
    property color dateAndTime: "#F6C177";
    property color volume: "#C4A7E7";
    property color network: "#EBBCBA";
    property color media: "#EB6F92";

    property color battery: "#31748F";
    property color batteryCharging: "#31748F";
    property color batteryMed: "#F6C177";
    property color batteryLow: red;
  }

  /*    _____________ ______________
       / __/_  __/ _ /_  __/ __/ __/
      _\ \  / / / __ |/ / / _/_\ \
     /___/ /_/ /_/ |_/_/ /___/___/   */

  enum ConfigState {
    Valid,
    Invalid,
    Validating
  }

  property int configValid: Globals.ConfigState.Validating;
  property list<string> configInvalidReasons: [];

  PersistentProperties {
    id: persist

    property bool menuOpen: false;
    property bool barHidden: false;
    property bool screensaverActive: false;
    property bool themeSwitchInProgress: false;
    property bool themeOverlayOpen: false;
    property string themeSwitchingState: "";
  }

  property alias states: persist;
}

