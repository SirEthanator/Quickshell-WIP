pragma ComponentBehavior: Bound

import qs.singletons
import qs.widgets.desktop // For LSP
import QtQuick;
import QtMultimedia;

Rectangle {
  id: root;
  anchors.fill: parent;

  layer.enabled: true;

  color: Conf.desktop.bgColour;

  Loader {
    active: Conf.desktop.wallpaperType === "video";
    asynchronous: true;
    anchors.fill: parent;

    sourceComponent: Item {
      anchors.fill: parent;

      VideoOutput {
        id: videoOut;
        anchors.fill: parent;
        fillMode: VideoOutput.PreserveAspectCrop;
      }

      MediaPlayer {
        id: videoPlayer;
        source: Controller.wallSource;
        autoPlay: true;
        loops: MediaPlayer.Infinite;
        videoOutput: videoOut;
      }
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

      source: Controller.wallSource;
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
      property real time: Controller.shaderTime;
      property vector4d mouse: Qt.vector4d(0, 0, 0, 0);

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
