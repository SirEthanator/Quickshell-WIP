pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.utils as Utils;
import qs.animations as Anims;
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root;
  visible: Globals.conf.desktop.clockWidget;
  // Baseline is on the centre of the widget
  spacing: Globals.vars.clockWidgetSpacing;

  Repeater {
    id: repeater;
    model: 6;
    readonly property string dateAndTime: Utils.SysInfo.dateAndTime;
    readonly property string time: dateAndTime
    .substring(dateAndTime.indexOf('|')+2, dateAndTime.length)
    .split(":")
    .join("");
    readonly property list<color> colours: [
      Globals.colours.accentLight,
      Globals.colours.accent,
      Globals.colours.accentLight,
      Globals.colours.accent,
      Globals.colours.accent,
      Globals.colours.accentDark
    ];

    Item {
      id: number;
      required property int index;
      readonly property bool secondDigit: (index + 1) % 2 === 0;
      // Spacing * 2 is added to width on every second number for triple spacing
      implicitWidth: stack.width + (secondDigit ? root.spacing * 2 : 0);
      implicitHeight: stack.height;
      clip: true;
      readonly property string digit: parseInt(repeater.time[index]);

      Stack {
        id: stack;
        currentIndex: number.digit;
        vertical: true;

        replaceEnter: Transition { Anims.Slide { offset: stack.height } }
        replaceExit: Transition { Anims.Slide { offset: stack.height; exit: true } }

        Repeater {
          model: 10;

          Rectangle {
            id: numberBg;
            required property int index;
            color: repeater.colours[number.index];
            width: numberText.width + Globals.vars.paddingCard;
            height: numberText.height + Globals.vars.paddingCard;
            Component.onCompleted: {
              stack.height = height;
              stack.width = width
            }

            Text {
              id: numberText;
              text: numberBg.index;
              color: Globals.colours.bg;
              anchors.centerIn: parent;
              font {
                family: Globals.vars.fontFamily;
                pixelSize: Globals.vars.xlFontSize;
              }
            }
          }
        }
      }
    }
  }
}

