import "root:/";
import Quickshell;
import QtQuick;

Item {
  id: root;
  anchors.fill: parent;
  // The default wallpaper must be set here instead of defaultConf.json because it uses an environment variable
  readonly property url wallSource: Globals.conf.background.wallpaper || Quickshell.env("HOME") + "/Hyprland-Dots/Wallpapers/Everforest/Hard.png";

  Image {
    id: img;
    visible: !Globals.conf.background.hideWallpaper;
    anchors.fill: parent;
    asynchronous: true;
    fillMode: Image.PreserveAspectCrop;
    source: root.wallSource;
  }

  ShaderEffect {
    id: shader;
    anchors.fill: parent;
    visible: Globals.conf.background.shader !== "";
    // These are passed into the shader:
    property vector2d resolution: Qt.vector2d(width, height);
    property real time: 0;
    FrameAnimation {
      running: true;
      onTriggered: {
        shader.time = this.elapsedTime;
      }
    }

    vertexShader: "shaders/default.vert.qsb";
    fragmentShader: visible ? "shaders/"+Globals.conf.background.shader+".frag.qsb" : undefined;
  }
}
