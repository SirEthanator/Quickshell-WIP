pragma Singleton

import qs.singletons
import qs.utils as Utils;
import Quickshell;
import QtQuick;
import Qt.labs.folderlistmodel;

Singleton {
  id: root;

  // The default wallpaper must be set here instead of defaultConf.json because it uses an environment variable
  readonly property string defaultWall: {
    switch (Conf.global.colourScheme) {
      case "everforest": return "Everforest"
      case "catMocha": return "Catppuccin"
      case "rosePine": return "Rose-Pine"
      default: return "Everforest"
    }
  }

  readonly property string defaultWallBasePath: `${Quickshell.env("HOME")}/Hyprland-Dots/Wallpapers/${defaultWall}`;

  readonly property url wallPath: Conf.desktop.wallpaper !== ""
    ? Conf.desktop.wallpaper
    : Conf.desktop.wallpaperType === "slideshow"
      ? defaultWallBasePath
      : `${defaultWallBasePath}/Accent.png`;

  property url wallSource: Conf.desktop.wallpaperType === "slideshow" ? slideshowCurrentPath : wallPath;

  property url slideshowCurrentPath: undefined;

  Timer {
    running: Conf.desktop.wallpaperType === "slideshow" && wallpaperModel.status === FolderListModel.Ready;
    interval: Conf.desktop.slideshowInterval * 1000;
    triggeredOnStart: true;
    repeat: true;

    property int currentIndex: 0;

    onTriggered: {
      root.slideshowCurrentPath = wallpaperModel.get(currentIndex % wallpaperModel.count, "fileUrl");
      currentIndex++;

      if (Conf.global.colourScheme === "material" && Conf.desktop.slideshowRegenMaterial) {
        Utils.SetTheme.setTheme("material", `--nonotify --wallpaper '${root.wallSource.toString().replace('file://', '')}'`);
      }
    }
  }

  FolderListModel {
    id: wallpaperModel;
    folder: Qt.resolvedUrl(root.wallPath);
    nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.svg"];
    showDirs: false;
    showOnlyReadable: true;
  }

  // TODO: Synchronise videos

  property real shaderTime: 0;

  FrameAnimation {
    running: Conf.desktop.shader !== "";
    onTriggered: {
      root.shaderTime = elapsedTime;
    }
  }
}
