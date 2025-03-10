import "root:/";
import QtQuick;

Item {
  anchors.fill: parent;

  Image {
    id: img;
    NumberAnimation on opacity {
      from: 0; to: 1;
      duration: Globals.background.fadeSpeed;
      easing.type: Easing.OutCubic
    }
    visible: !Globals.background.hideWallpaper;
    anchors.fill: parent;
    asynchronous: true;
    fillMode: Image.PreserveAspectCrop;
    source: Globals.background.wallpaper;
  }

  ShaderEffect {
    id: shader;
    anchors.fill: parent;
    visible: Globals.background.shader !== "";
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
    fragmentShader: "shaders/"+Globals.background.shader+".frag.qsb";
  }
}
