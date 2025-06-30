import "root:/";
import "root:/animations" as Anims;
import QtQuick;

Item {
  id: root

  property real value: 0;
  property real thickness: 7;
  property color bg: Globals.colours.bg;
  property color fg: Globals.colours.accent;
  property real startAngle: 135;
  property real maxAngle: 270;

  onValueChanged: canvas.requestPaint();
  onBgChanged: canvas.requestPaint();
  onFgChanged: canvas.requestPaint();
  onThicknessChanged: canvas.requestPaint();

  property int fontSize: Globals.vars.mainFontSize;
  property color fontColour: Globals.colours.fg;

  Anims.NumberTransition on value {}

  Canvas {
    id: canvas;
    anchors.fill: parent;

    onPaint: {
      const ctx = getContext("2d");
      const centerX = width / 2;
      const centerY = height / 2;
      const radius = Math.min(width, height) / 2 - root.thickness / 2;

      ctx.clearRect(0, 0, width, height);
      ctx.lineWidth = root.thickness;
      ctx.lineCap = "round";

      // Background
      ctx.beginPath();
      ctx.strokeStyle = root.bg;
      const startAngleRad = root.startAngle * Math.PI / 180;
      const maxAngleRad = root.maxAngle * Math.PI / 180;
      const endBackgroundAngleRad = startAngleRad + 1 * maxAngleRad;
      ctx.arc(centerX, centerY, radius, startAngleRad, endBackgroundAngleRad, false);
      ctx.stroke();

      // Foreground (progress)
      if (root.value > 0) {
        ctx.beginPath();
        ctx.strokeStyle = root.fg;
        const progressAngleRad = startAngleRad + 1 * root.value * maxAngleRad;
        ctx.arc(centerX, centerY, radius, startAngleRad, progressAngleRad, false);
        ctx.stroke();
      }
    }
  }

  Text {
    anchors.centerIn: parent;
    text: `${Math.round(root.value * 100)}%`;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: root.fontSize;
    }
    color: root.fontColour;
  }
}
