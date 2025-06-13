# SYNOPSIS

```
{
  "colourScheme": string,

  "bar": {
    "left": [ string ],
    "centre": [ string ],
    "right": [ string ],
    "autohide": bool,
    "docked": bool,
    "floatingModules": bool,
    "multiColourModules": bool,
    "moduleOutlines": bool,
    "backgroundOutline": bool,
    "workspaceCount": int,
    "truncationLength": int
  },

  "menu": {
    "width": int,
    "capitaliseUsername": bool,
    "capitaliseHostname": bool
  },

  "desktop": {
    "wallpaper": string,
    "videoWallpaper": bool,
    "fadeSpeed": int,
    "shader": string,
    "hideWallpaper": bool,
    "bgColour": color,
    "clockWidget": bool,
    "centreClockWidget": bool,
    "autohideWidgets": bool,
    "autohideBar": bool,
    "autohideCursor": bool
  },

  "notifications": {
    "width": int,
    "defaultTimeout": int,
    "defaultCriticalTimeout": int,
    "sounds": bool,
    "normalSound": string,
    "criticalSound": string,
    "dismissThreshold": real
  }
}
```

# GENERAL

## colourScheme

Defines what colour scheme should be used.

Type: "everforest" | "catMocha" | "rosePine"

Default: `"everforest"`


# BAR

## left

Defines what modules to show on the left of the bar (LTR).

Type: Array of strings

Default: `["menu", "workspaces", "activeWindow"]`

## centre

Defines what modules to show in the middle of the bar (LTR).

Type: Array of strings

Default: `[ "dateAndTime" ]`

## right

Defines what modules to show on the right of the bar (LTR).

Type: Array of strings

Default: `[ "network", "battery", "media", "volume" ]`

## autohide

Defines whether the bar should automatically hide until the top edge of the screen is hovered.

Type: Boolean

Default: `false`

## docked

Defines whether the bar should touch the screen edges.

Type: Boolean

Default: `false`

## floatingModules

Defines whether the bar's background should be shown.

Type: Boolean

Default: `false`

## multiColourModules

Defines whether the icons should have different coloured backgrounds.

Type: Boolean

Default: `false`

## moduleOutlines

Defines whether modules should have an outline around them.

Type: Boolean

Default: `true`

## backgroundOutline

Defines whether the bar's background should have an outline around it.

Type: Boolean

Default: `true`

## workspaceCount

Defines how many workspaces should be shown on the workspace module.

Type: Integer

Default: `10`


## truncationLength

Defines the maximum length for modules with long text.

Type: Integer

Default: `60`


# MENU

## width

Defines how wide the menu should be (px).

Type: Integer

Default: `600`

## capitaliseUsername

Defines whether the user's username should be capitalised.

Type: Boolean

Default: `true`

## capitaliseHostname

Defines whether the system's hostname should be capitalised.

Type: Boolean

Default: `false`


# DESKTOP

## wallpaper

Defines the path to the wallpaper to show. Setting it to an empty string will use the default.

Type: String

Default: `""`

## videoWallpaper

Defines whether the wallpaper specified in the `wallpaper` option is a video.

Type: Boolean

Default: `false`

## fadeSpeed

Defines how long the wallpaper should fade in for when the shell is launched (ms). Set to 0 to disable.

Type: int

Default: `2000`

## shader

Defines the path to the shader to show. This is displayed on top of the wallpaper. Set to an empty string to disable.

Type: String

Default: `""`

## hideWallpaper

Defines whether the wallpaper should be hidden.

Type: Boolean

Default: `false`

## bgColour

Defines the colour that should be shown behind everything. If `hideWallpaper` is true, this colour will be displayed. It is also useful for shaders which look better with a solid colour behind them

Type: Color

Default: `"black"`

## clockWidget

Defines whether the clock widget should be shown.

Type: Boolean

Default: `false`

## centreClockWidget

Defines whether the clock widget should be vertically centred.

Type: Boolean

Default: `false`

## autohideWidgets

Defines whether widgets should be hidden after a delay when there is no activity on the desktop.

Type: Boolean

Default: `false`

## autohideBar

Defines whether the bar should be hidden after a delay when there is no activity on the desktop. This will only hide the bar when the desktop has focus.

Type: Boolean

Default: `false`

## autohideCursor

Defines whether the cursor should be hidden after a delay when there is no activity on the desktop. This will only hide the cursor when the desktop has focus.

Type: Boolean

Default: `false`


# NOTIFICATIONS

## width

Defines the width of notifications (px).

Type: Integer

Default: `500`

## defaultTimeout

Defines the default timeout for notifications when the sender does not specify one (ms).

Type: Integer

Default: `5000`

## defaultCriticalTimeout

Defines the default timeout for critical notifications when the sender does not specify one (ms).

Type: Integer

Default: `8000`


## sounds

Defines whether to play a sound on incoming notifications.

Type: Boolean

Default: `true`

## normalSound

Defines the path to the sound to play for non-critical notifications.

Type: String

Default: `"/usr/share/sounds/ocean/stereo/message-new-instant.oga"`

## criticalSound

Defines the path to the sound to play for critical notifications.

Type: String

Default: `"/usr/share/sounds/ocean/stereo/dialog-error-critical.oga"`

## dismissThreshold

Defines what percentage of `width` notifications must be dragged to dismiss them.

Type: Integer

Default: `30`

