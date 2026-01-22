pragma Singleton

import qs.utils
import qs.singletons.modules.config
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;
  readonly property url confPath: Qt.resolvedUrl(Quickshell.shellPath("config.conf"));

  function getCategoryKeys() {
    return Object.keys(metadata);
  }

  // Metadata format:
  // "category (matches name of property containing the corresponding ConfigCategory)": {
  //   "section (name which should be displayed)": {
  //     "option (matches name of property in the ConfigCategory)": {
  //       option metadata here
  //     }
  //   }
  // }

  QtObject {
    id: stripped;

    readonly property var barModules: Consts.barModules.toStripped();
    readonly property var dashModules: Consts.dashModules.toStripped();
    readonly property var wallpaperTypes: Consts.wallpaperTypes.toStripped();
  }

  readonly property var metadata: ({
    "global": {
      "Appearance": {
        "colourScheme": {
          "title": "Colour Scheme",
          "description": "Defines what colour scheme should be used throughout the system.",
          "type": "string",
          "options": Globals.schemes,
          "callback": root.switchTheme
        }
      }
    },

    "bar": {
      "Modules": {
        "left": {
          "title": "Left Modules",
          "description": "Defines what modules to show on the left of the bar (LTR).",
          "type": "list<string>",
          "options": stripped.barModules
        },
        "centre": {
          "title": "Centre Modules",
          "description": "Defines what modules to show in the middle of the bar (LTR).",
          "type": "list<string>",
          "options": stripped.barModules
        },
        "right": {
          "title": "Right Modules",
          "description": "Defines what modules to show on the right of the bar (LTR).",
          "type": "list<string>",
          "options": stripped.barModules
        }
      },
      "Behaviour": {
        "autohide": {
          "title": "Autohide",
          "description": "Defines whether the bar should automatically hide until the top edge of the screen is hovered.",
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
      "Appearance": {
        "floatingModules": {
          "title": "Floating Modules",
          "description": "Defines whether the bar's background should be shown.",
          "type": "bool"
        },
        "docked": {
          "title": "Docked",
          "description": "Defines whether the bar should touch the screen edges.",
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
        }
      }
    },

    "sidebar": {
      "Appearance": {
        "dimBackground": {
          "title": "Dim Background",
          "description": "Defines whether the background behind the sidebar should be dimmed.",
          "type": "bool"
        },
        "backgroundOutline": {
          "title": "Background Outline",
          "description": "Defines whether the sidebar's background should have an outline around it.",
          "type": "bool"
        },
        "moduleOutlines": {
          "title": "Module Outlines",
          "description": "Defines whether items should have outlines around them.",
          "type": "bool"
        },
        "width": {
          "title": "Width",
          "description": "Defines how wide the menu should be (px).",
          "type": "int",
          "max": 5000,
          "min": 400
        }
      }
    },

    "menu": {
      "Behaviour": {
        "dashModules": {
          "title": "Dashboard Modules",
          "description": "Defines which modules should be shown on the dashboard.",
          "type": "list<string>",
          "options": stripped.dashModules
        }
      },
      "Appearance": {
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
        }
      }
    },

    "desktop": {
      "General": {
        "wallpaper": {
          "title": "Wallpaper Path",
          "description": "Defines the path to the wallpaper to show. Set to an empty string to use the default.",
          "type": "path",
          "getFileTypes": (getVal) => {
            let result;

            switch (getVal("desktop", "wallpaperType")) {
              case "video":
                return ["Video files (*.mp4)"];
              case "slideshow":
                return "Directories";
              default:
                return ["Image files (*.png *.jpg *.jpeg *.svg)"];
            }
          },
          "allowEmpty": true,
          "callback": (val, getVal) => {
            if (getVal("global", "colourScheme") === "material" && getVal("desktop", "wallpaperType") !== "slideshow") {
              Quickshell.execDetached(['bash', '-c', `${Quickshell.env("HOME")}/Scripts/SetTheme material --noconfirm --wallpaper '${val.replace('file://', '')}'`])
            }
          }
        },
        "backdropWallpaper": {
          "title": "Backdrop Wallpaper",
          "description": "Defines whether a second wallpaper component with blur should be shown. This is intended for placing in niri's workspace overview. If it is not, it may show on top of the normal wallpaper. It is recommended to disable this if you are not using it. It may have a negative performance impact, especially with video wallpapers. It has the namespace 'backdrop-wallpaper'",
          "type": "bool"
        },
        "wallpaperType": {
          "title": "Wallpaper Type",
          "description": "Defines what type of wallpaper should be used.",
          "type": "string",
          "options": stripped.wallpaperTypes
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
          "description": "Defines the name of the shader to show. This is displayed on top of the wallpaper. Set to an empty string to disable. Additional shaders may be placed in <shellRoot>/widgets/desktop/shaders.",
          "type": "string"
        },
        "bgColour": {
          "title": "Background Colour",
          "description": "Defines the colour that should be shown behind everything. If 'hideWallpaper' is true, this colour will be displayed. It is also useful for shaders which look better with a solid colour behind them.",
          "type": "string"
        }
      },
      "Slideshow": {
        "_getIsVisible": (getVal) => {
          return getVal("desktop", "wallpaperType") === "slideshow";
        },
        "slideshowInterval": {
          "title": "Slideshow Interval",
          "description": "Defines how long to show each wallpaper for in seconds.",
          "type": "int",
          "min": 1
        }
      }
    },

    "notifications": {
      "Behaviour": {
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
      }
    },

    "lock": {
      "Appearance": {
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
      }
    },

    "osd": {
      "Behaviour": {
        "backlightName": {
          "title": "Backlight Name",
          "description": `Defines the name of the display's backlight. This is used to get the path of the backlight: /sys/class/backlight/<backlightName>

Some common options are: 'intel_backlight' and 'acpi_video0'. You can find the correct one for your display by running: ls /sys/class/backlight`,
          "type": "string"
        }
      }
    },

    // "polkit": {}
  })

  property GlobalConf global: GlobalConf {}
  property BarConf bar: BarConf {}
  property SidebarConf sidebar: SidebarConf {}
  property MenuConf menu: MenuConf {}
  property DesktopConf desktop: DesktopConf {}
  property NotificationConf notifications: NotificationConf {}
  property LockConf lock: LockConf {}
  property OSDConf osd: OSDConf {}
  // property PolkitConf polkit: PolkitConf {}

  // Use when section is not accessible. If it is, accessing metadata
  // directly is more efficient.
  function getMetadata(category: string, option: string): var {
    for (const sectionName in metadata[category]) {
      const section = metadata[category][sectionName];
      if (section && typeof section === "object" && option in section) {
        return section[option]
      }
    }
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
    const validationResult = setColours(scheme);
    if (!!validationResult) return validationResult
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
