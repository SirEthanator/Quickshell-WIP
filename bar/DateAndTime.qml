import "root:/";
import Quickshell;
import QtQuick;

BarModule {
  icon: "calendar-symbolic";
  iconbgColour: Globals.colours.dateAndTime;

  SystemClock {
    id: clock;
    precision: SystemClock.Seconds;
  }

  Text {
    id: clockText
    color: Globals.colours.fg;
    font: Globals.vars.mainFont

    text: {
      const hoursTmp = (clock.hours < 13) ? clock.hours : clock.hours - 12;
      const hours   = hoursTmp.toString().padStart(2, '0');
      const minutes = clock.minutes.toString().padStart(2, '0');
      const seconds = clock.seconds.toString().padStart(2, '0');
      const ampm = (clock.hours < 12) ? 'AM' : 'PM';
      const date = new Date().toLocaleString(Qt.locale(), "ddd dd/MM/yy");
      return `${date} | ${hours}:${minutes}:${seconds} ${ampm}`;
    }
  }
}
