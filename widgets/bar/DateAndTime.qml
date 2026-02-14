pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls as Ctrls;

BarModule {
  icon: "calendar-month-symbolic";
  iconbgColour: Globals.colours.dateAndTime;

  Text {
    color: Globals.colours.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }

    text: SysInfo.dateTime("ddd dd/MM | hh:mm ap");
  }

  tooltip: Tooltip {
    Text {
      text: `Date & Time - ${SysInfo.dateTime("ddd dd/MM/yy | hh:mm:ss ap")}`;
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }

  menu: Tooltip {
    ColumnLayout {
      RowLayout {
        Layout.fillWidth: true;
        spacing: Consts.spacingButtonGroup;

        Button {
          icon: "previous-symbolic";
          iconSize: Consts.smallIconSize;
          padding: Consts.paddingButtonIcon;
          bg: Globals.colours.bgLight;
          tlRadius: true;
          blRadius: true;
          onClicked: monthGrid.incrementMonth(-1);
        }

        Button {
          Layout.fillWidth: true;
          Layout.fillHeight: true;

          bg: Globals.colours.bgLight;

          padding: 0;

          onClicked: {
            const date = new Date();
            monthGrid.month = date.getMonth();
            monthGrid.year = date.getFullYear();
          }

          label: `${monthGrid.monthString} ${monthGrid.year}`
          fontSize: Consts.mediumFontSize;
          boldFont: true;
        }

        Button {
          icon: "next-symbolic";
          iconSize: Consts.smallIconSize;
          padding: Consts.paddingButtonIcon;
          bg: Globals.colours.bgLight;
          trRadius: true;
          brRadius: true;
          onClicked: monthGrid.incrementMonth(1);
        }
      }

      Item {
        implicitHeight: Consts.paddingModule - parent.spacing;
      }

      RowLayout {
        Repeater {
          model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
          delegate: Text {
            required property string modelData;
            text: modelData;
            color: Globals.colours.fg;

            font {
              family: Consts.fontFamily;
              pixelSize: Consts.mainFontSize;
              italic: true;
            }
          }
        }

        Layout.fillWidth: true;
      }

      Ctrls.MonthGrid {
        id: monthGrid;
        Layout.fillWidth: true;

        delegate: Text {
          required property var modelData;
          text: modelData.day;
          color: modelData.today
            ? Globals.colours.accent
            : modelData.month === monthGrid.month
              ? Globals.colours.fg
              : Globals.colours.greyDim;

          font {
            family: Consts.fontFamily;
            pixelSize: Consts.mainFontSize;
            bold: modelData.today;
          }

          horizontalAlignment: Text.AlignHCenter;
          verticalAlignment: Text.AlignVCenter;
        }

        readonly property var monthMap: {
          0: "January",
          1: "February",
          2: "March",
          3: "April",
          4: "May",
          5: "June",
          6: "July",
          7: "August",
          8: "September",
          9: "October",
          10: "November",
          11: "December"
        }
        readonly property string monthString: monthMap[month];

        function incrementMonth(amount: int) {
          const totalMonths = year * 12 + month + amount;
          const newYear = Math.floor(totalMonths / 12);
          const newMonth = totalMonths % 12;

          year = newYear;
          month = newMonth;
        }
      }
    }
  }
}
