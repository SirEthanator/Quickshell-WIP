pragma Singleton

import "utils";
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;
  readonly property url confPath: Qt.resolvedUrl("./config.conf");

  function getCategoryKeys() {
    return Object.keys(metadata);
  }

  readonly property var metadata: ({
    "global": {
      "colourScheme": {
        "title": "Colour Scheme",
        "description": "Defines what colour scheme should be used throughout the system.",
        "type": "string",
        "options": Globals.schemes,
        "callback": root.switchTheme
      }
    },

    "bar": {
      "left": {
        "title": "Left Modules",
        "description": "Defines what modules to show on the left of the bar (LTR).",
        "type": "list<string>",
        "options": Globals.vars.barModules
      },
      "centre": {
        "title": "Centre Modules",
        "description": "Defines what modules to show in the middle of the bar (LTR).",
        "type": "list<string>",
        "options": Globals.vars.barModules
      },
      "right": {
        "title": "Right Modules",
        "description": "Defines what modules to show on the right of the bar (LTR).",
        "type": "list<string>",
        "options": Globals.vars.barModules
      },
      "autohide": {
        "title": "Autohide",
        "description": "Defines whether the bar should automatically hide until the top edge of the screen is hovered.",
        "type": "bool"
      },
      "docked": {
        "title": "Docked",
        "description": "Defines whether the bar should touch the screen edges.",
        "type": "bool"
      },
      "floatingModules": {
        "title": "Floating Modules",
        "description": "Defines whether the bar's background should be shown.",
        "type": "bool"
      },
      "multiColourModules": {
        "title": "Multi-colour Modules",
        "description": "Defines whether the icons should have different coloured backgrounds.",
        "type": "bool"
      },
      "moduleOutlines": {
        "title": "Module Outlines",
        "description": "Defines whether modules should have an outline around them.",
        "type": "bool"
      },
      "backgroundOutline": {
        "title": "Background Outline",
        "description": "Defines whether the bar's background should have an outline around it.",
        "type": "bool"
      },
      "workspaceCount": {
        "title": "Workspace Count",
        "description": "Defines how many workspaces should be shown on the workspace module.",
        "type": "int",
        "max": 20,
        "min": 1
      },
      "truncationLength": {
        "title": "Truncation Length",
        "description": "Defines the maximum length for modules with long text.",
        "type": "int",
        "max": 1000,
        "min": 0
      }
    },

    "menu": {
      "dashModules": {
        "title": "Dashboard Modules",
        "description": "Defines which modules should be shown on the dashboard.",
        "type": "list<string>",
        "options": Globals.vars.dashModules
      },
      "profilePicture": {
        "title": "Profile Picture",
        "description": "Defines the path to the profile picture to use. Set to an empty string to use the default.",
        "type": "path",
        "allowEmpty": true
      },
      "capitaliseUsername": {
        "title": "Capitalise Username",
        "description": "Defines whether the user's username should be capitalised.",
        "type": "bool"
      },
      "capitaliseHostname": {
        "title": "Capitalise Hostname",
        "description": "Defines whether the system's hostname should be capitalised.",
        "type": "bool"
      },
      "dimBackground": {
        "title": "Dim Background",
        "description": "Defines whether the background behind the menu should be dimmed.",
        "type": "bool"
      },
      "backgroundOutline": {
        "title": "Background Outline",
        "description": "Defines whether the menu's background should have an outline around it.",
        "type": "bool"
      },
      "moduleOutlines": {
        "title": "Module Outlines",
        "description": "Defines whether dashboard modules and launcher items should have outlines around them.",
        "type": "bool"
      },
      "width": {
        "title": "Width",
        "description": "Defines how wide the menu should be (px).",
        "type": "int",
        "max": 5000,
        "min": 450
      }
    },

    "desktop": {
      "wallpaper": {
        "title": "Wallpaper",
        "description": "Defines the path to the wallpaper to show. Set to an empty string to use the default.",
        "type": "path",
        "allowEmpty": true,
        "callback": (val, getVal) => {
          if (getVal("global", "colourScheme") === "material") {
            Quickshell.execDetached(['bash', '-c', `${Quickshell.env("HOME")}/Scripts/SetTheme material --noconfirm --wallpaper '${val.replace('file://', '')}'`])
          }
        }
      },
      "videoWallpaper": {
        "title": "Video Wallpaper",
        "description": "Defines whether the wallpaper specified in the 'wallpaper' option is a video.",
        "type": "bool"
      },
      "fadeSpeed": {
        "title": "Fade Duration",
        "description": "Defines how long the wallpaper should fade in for when the shell is launched (ms). Set to 0 to disable.",
        "type": "int",
        "max": 60000,
        "min": 0
      },
      "shader": {
        "title": "Shader",
        "description": "Defines the path to the shader to show. This is displayed on top of the wallpaper. Set to an empty string to disable.",
        "type": "string"
      },
      "hideWallpaper": {
        "title": "Hide Wallpaper",
        "description": "Defines whether the wallpaper should be hidden.",
        "type": "bool"
      },
      "bgColour": {
        "title": "Background Colour",
        "description": "Defines the colour that should be shown behind everything. If 'hideWallpaper' is true, this colour will be displayed. It is also useful for shaders which look better with a solid colour behind them.",
        "type": "string"
      }
    },

    "notifications": {
      "width": {
        "title": "Width",
        "description": "Defines the width of notifications (px).",
        "type": "int",
        "max": 5000,
        "min": 200
      },
      "defaultTimeout": {
        "title": "Default Timeout",
        "description": "Defines the default timeout for notifications when the sender does not specify one (ms).",
        "type": "int",
        "max": 60000,
        "min": 100
      },
      "defaultCriticalTimeout": {
        "title": "Default Critical Timeout",
        "description": "Defines the default timeout for critical notifications when the sender does not specify one (ms).",
        "type": "int",
        "max": 60000,
        "min": 100
      },
      "minimumTimeout": {
        "title": "Minimum Timeout",
        "description": "Defines the minimum timeout for all notifications.",
        "type": "int",
        "max": 60000,
        "min": 100
      },
      "minimumCriticalTimeout": {
        "title": "Minimum Critical Timeout",
        "description": "Defines the minimum timeout for all critical notifications.",
        "type": "int",
        "max": 60000,
        "min": 100
      },
      "sounds": {
        "title": "Sounds",
        "description": "Defines whether to play a sound on incoming notifications.",
        "type": "bool"
      },
      "normalSound": {
        "title": "Normal Sound",
        "description": "Defines the path to the sound to play for non-critical notifications.",
        "type": "path"
      },
      "criticalSound": {
        "title": "Critical Sound",
        "description": "Defines the path to the sound to play for critical notifications.",
        "type": "path"
      },
      "dismissThreshold": {
        "title": "Dismiss Threshold",
        "description": "Defines what percentage of 'width' notifications must be dragged to dismiss them.",
        "type": "int",
        "max": 99,
        "min": 1
      }
    },

    "lock": {
      "dimBackground": {
        "title": "Dim Background",
        "description": "Defines whether the background should be dimmed.",
        "type": "bool"
      },
      "contentOutline": {
        "title": "Content Outline",
        "description": "Defines whether the rectangle containing the clock, input, etc. should have an outline around it.",
        "type": "bool"
      },
      "noFade": {
        "title": "Disable Fade In/Out",
        "description": "Defines whether the background should fade in and out. Useful on niri where the fade will result in a red flash.",
        "type": "bool"
      }
    },

    "osd": {
      "backlightName": {
        "title": "Backlight Name",
        "description": `Defines the name of the display's backlight. This is used to get the path of the backlight: \`/sys/class/backlight/<backlightName>\`

Some common options are: 'intel_backlight' and 'acpi_video0'. You can find the correct one for your display by running ls /sys/class/backlight`,
        "type": "string"
      }
    },

    "polkit": {
      "dimBackground": {
        "title": "Dim Background",
        "description": "Defines whether the background should be dimmed.",
        "type": "bool"
      },
      "hideApplications": {
        "title": "Hide Applications",
        "description": "Defines whether applications should be hidden when a prompt is shown.",
        "type": "bool"
      },
      "backgroundOutline": {
        "title": "Outline",
        "description": "Defines whether the content's background should have an outline around it.",
        "type": "bool"
      },
    }
  })

  property ConfigCategory global: ConfigCategory {
    category: "Global";

    property string colourScheme: "everforest";
  }

  property ConfigCategory bar: ConfigCategory {
    category: "Bar";

    property list<string> left: [
      "menu",
      "workspaces",
      "activeWindow"
    ];
    property list<string> centre: ["dateAndTime"];
    property list<string> right: [
      "tray",
      "network",
      "battery",
      "media",
      "volume"
    ];
    property bool autohide: false;
    property bool docked: false;
    property bool floatingModules: false;
    property bool multiColourModules: false;
    property bool moduleOutlines: true;
    property bool backgroundOutline: true;
    property int workspaceCount: 10;
    property int truncationLength: 60;
  }

  property ConfigCategory menu: ConfigCategory {
    category: "Menu";

    property list<string> dashModules: [
      "userInfo",
      "sysStats",
      "notifCentre"
    ];
    property string profilePicture: "";
    property bool capitaliseUsername: false;
    property bool capitaliseHostname: false;
    property bool dimBackground: true;
    property bool backgroundOutline: true;
    property bool moduleOutlines: true;
    property int width: 600;
  }

  property ConfigCategory desktop: ConfigCategory {
    category: "Desktop";

    property string wallpaper: "";
    property bool videoWallpaper: false;
    property int fadeSpeed: 2000;
    property string shader: "";
    property bool hideWallpaper: false;
    property color bgColour: "black";
  }

  property ConfigCategory notifications: ConfigCategory {
    category: "Notifications";

    property int width: 500;
    property int defaultTimeout: 5000;
    property int defaultCriticalTimeout: 8000;
    property int minimumTimeout: 2000;
    property int minimumCriticalTimeout: 4000;
    property bool sounds: true;
    property string normalSound: "/usr/share/sounds/ocean/stereo/message-new-instant.oga";
    property string criticalSound: "/usr/share/sounds/ocean/stereo/dialog-error-critical.oga";
    property int dismissThreshold: 30;
  }

  property ConfigCategory lock: ConfigCategory {
    category: "Lock";

    property bool dimBackground: false;
    property bool contentOutline: true;
    property bool noFade: false;
  }

  property ConfigCategory osd: ConfigCategory {
    category: "OSD";

    property string backlightName: "";
  }

  property ConfigCategory polkit: ConfigCategory {
    category: "Polkit";

    property bool dimBackground: true;
    property bool hideApplications: false;
    property bool backgroundOutline: true;
  }

  function setConf(category: string, option: string, value, validate): string {
    const validationResult = (typeof validate === "function") ? validate() : undefined;
    if (!!validationResult) return validationResult;

    if (!category || !option || !root[category][option])
      return `No such option: ${category}/${option}`;

    root[category][option] = value;
    return ""
  }

  function setColours(scheme: string): string {
    const validate = () => Validate.validateObjKey(scheme, Globals.schemes, "Failed to set colour scheme");
    return setConf("global", "colourScheme", scheme, validate);
  }

  function setWallpaper(path: string): void {
    setConf('desktop', 'wallpaper', path);
  }

  function switchTheme(scheme: string): string {
    const validationResult = Validate.validateObjKey(scheme, Globals.schemes, "Failed to set colour scheme");
    if (validationResult) return validationResult;
    setColours(scheme);
    setTheme.scheme = scheme;
    setTheme.startDetached();
    return "";
  }

  Process {
    id: setTheme;

    property string scheme: "";
    command: ["sh", "-c", `${Quickshell.env("HOME")}/Scripts/SetTheme ${scheme} --noconfirm`];
  }
}

