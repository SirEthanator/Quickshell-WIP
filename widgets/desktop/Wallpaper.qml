pragma ComponentBehavior: Bound

import qs.singletons
import Quickshell;  // Despite what qmlls says, this is not unused. Do not remove.
import QtQuick;
import QtMultimedia;
import Qt.labs.folderlistmodel;

Rectangle {
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

  layer.enabled: true;

  color: Conf.desktop.bgColour;

  VideoOutput {
    id: videoOut;
    anchors.fill: parent;
    fillMode: VideoOutput.PreserveAspectCrop;
  }

  Loader {
    active: Conf.desktop.wallpaperType === "video";
    asynchronous: true;

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
    active: Conf.desktop.wallpaperType === "regular" || Conf.desktop.wallpaperType === "slideshow";
    asynchronous: true;
    anchors.fill: parent;

    sourceComponent: Image {
      id: img;
      anchors.fill: parent;

      asynchronous: true;
      retainWhileLoading: true;

      smooth: true;
      antialiasing: true;
      fillMode: Image.PreserveAspectCrop;

      // FIXME: Doesn't change when switching from slideshow to regular
      source: Conf.desktop.wallpaperType === "regular" ? root.wallSource : undefined;

      Loader {
        // TODO: Use a singleton to manage wallpaper state, allows below comments to be done
        // TODO: Sync slideshow across lock, desktop, and backdrop
        // TODO: SetTheme on change for material

        active: Conf.desktop.wallpaperType === "slideshow";
        asynchronous: true;

        Timer {
          running: wallpaperModel.status === FolderListModel.Ready && parent.active;
          interval: Conf.desktop.slideshowInterval * 1000;
          triggeredOnStart: true;
          repeat: true;

          property int currentIndex: 0;

          onTriggered: {
            img.source = wallpaperModel.get(currentIndex % wallpaperModel.count, "fileUrl");
            currentIndex++;
          }
        }

        FolderListModel {
          id: wallpaperModel;
          folder: Qt.resolvedUrl(Conf.desktop.wallpaper);
          nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.svg"];
          showDirs: false;
          showOnlyReadable: true;
        }
      }
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
      property vector4d mouse: Qt.vector4d(0, 0, 0, 0);

      FrameAnimation {
        running: true;
        onTriggered: {
          shader.time = this.elapsedTime;
        }
      }

      fragmentShader: Qt.resolvedUrl("shaders/"+Conf.desktop.shader+".frag.qsb");

      MouseArea {
        id: shaderMouseArea;
        anchors.fill: parent;
        hoverEnabled: true;

        onPositionChanged: {
          shader.mouse.x = mouseX;
          shader.mouse.y = shader.height - mouseY;

          if (pressed) {
            shader.mouse.z = mouseX;
            shader.mouse.w = shader.height - mouseY;
          }
        }
        onPressed: {
          shader.mouse.z = mouseX;
          shader.mouse.w = mouseY;
        }
        onReleased: {
          shader.mouse.z = -Math.abs(shader.mouse.z);
          shader.mouse.w = -Math.abs(shader.mouse.w);
        }
      }
    }
  }
}
