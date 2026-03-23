pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.panels.bar
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls as Ctrls;

BarModule {
  icon: "calendar-month-symbolic";
  iconbgColor: Colors.c.dateAndTime;

  Text {
    color: Colors.c.fg;
    font {
      family: Consts.fontFamMain;
      pixelSize: Consts.fontSizeMain;
    }

    text: SysInfo.dateTime("ddd dd/MM | hh:mm ap");
  }

  tooltip: Tooltip {
    Text {
      text: `Date & time - ${SysInfo.dateTime("ddd dd/MM/yy | hh:mm:ss ap")}`;
      color: Colors.c.fg;
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeMain;
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
          iconSize: Consts.iconSizeSmall;
          padding: Consts.paddingButtonIcon;
          bg: Colors.c.bgLight;
          tlRadius: true;
          blRadius: true;
          onClicked: monthGrid.incrementMonth(-1);
        }

        Button {
          Layout.fillWidth: true;
          Layout.fillHeight: true;

          bg: Colors.c.bgLight;

          padding: 0;

          onClicked: {
            const date = new Date();
            monthGrid.month = date.getMonth();
            monthGrid.year = date.getFullYear();
          }

          label: `${monthGrid.monthString} ${monthGrid.year}`
          fontSize: Consts.fontSizeMedium;
          boldFont: true;
        }

        Button {
          icon: "next-symbolic";
          iconSize: Consts.iconSizeSmall;
          padding: Consts.paddingButtonIcon;
          bg: Colors.c.bgLight;
          trRadius: true;
          brRadius: true;
          onClicked: monthGrid.incrementMonth(1);
        }
      }

      Item {
        implicitHeight: Consts.paddingSmall - parent.spacing;
      }

      RowLayout {
        Repeater {
          id: dayRepeater;
          readonly property list<string> days: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
          model: days.length;

          delegate: Text {
            required property int index;
            text: dayRepeater.days[(index + Qt.locale().firstDayOfWeek) % 7];
            color: Colors.c.fg;

            font {
              family: Consts.fontFamMain;
              pixelSize: Consts.fontSizeMain;
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
            ? Colors.c.accent
            : modelData.month === monthGrid.month
              ? Colors.c.fg
              : Colors.c.greyDim;

          font {
            family: Consts.fontFamMain;
            pixelSize: Consts.fontSizeMain;
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
