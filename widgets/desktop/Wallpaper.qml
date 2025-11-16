pragma ComponentBehavior: Bound

import qs
import Quickshell;  // Despite what qmlls says, this is not unused. Do not remove.
import QtQuick;
import QtMultimedia;

Item {
  id: root;
  anchors.fill: parent;
  // The default wallpaper must be set here instead of defaultConf.json because it uses an environment variable
  readonly property string defaultWall: {
    switch (Conf.global.colourScheme) {
      case "everforest": return "Everforest"
      case "catMocha": return "Catppuccin"
      case "rosePine": return "Rose-Pine"
      default: return "Everforest"
    }
  }
  readonly property url wallSource: Conf.desktop.wallpaper !== ""
    ? Conf.desktop.wallpaper
    : `${Quickshell.env("HOME")}/Hyprland-Dots/Wallpapers/${defaultWall}/Accent.png`;
  readonly property bool showWall: !Conf.desktop.hideWallpaper;

  layer.enabled: true;

  VideoOutput {
    id: videoOut;
    anchors.fill: parent;
    fillMode: VideoOutput.PreserveAspectCrop;
  }

  Loader {
    active: Conf.desktop.videoWallpaper && root.showWall;
    sourceComponent: MediaPlayer {
      id: videoPlayer;
      source: root.wallSource;
      autoPlay: true;
      loops: MediaPlayer.Infinite;
      videoOutput: videoOut;
      // audioOutput: AudioOutput {}
    }
  }

  Loader {
    active: !Conf.desktop.videoWallpaper && root.showWall;
    anchors.fill: parent;
    sourceComponent: Image {
      id: img;
      anchors.fill: parent;
      asynchronous: true;
      fillMode: Image.PreserveAspectCrop;
      source: root.wallSource;
    }
  }

  Loader {
    active: Conf.desktop.shader !== "";
    anchors.fill: parent;
    sourceComponent: ShaderEffect {
      id: shader;
      anchors.fill: parent;
      // These are passed into the shader:
      property vector2d resolution: Qt.vector2d(width, height);
      property real time: 0;
      FrameAnimation {
        running: true;
        onTriggered: {
          shader.time = this.elapsedTime;
        }
      }

      vertexShader: Qt.resolvedUrl("shaders/default.vert.qsb");
      fragmentShader: Qt.resolvedUrl("shaders/"+Conf.desktop.shader+".frag.qsb");
    }
  }
}
