import ".."
import Quickshell
import QtQuick

BarModule {
  implicitWidth: clockText.implicitWidth + Globals.vars.paddingModule

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Text {
    id: clockText
    anchors.centerIn: parent
    color: Globals.colours.fg
    font.pixelSize: Globals.vars.fontMain

    text: {
      const raw = new Date()
      const hoursTmp = (clock.hours < 13) ? clock.hours : clock.hours - 12
      const hours   = hoursTmp.toString().padStart(2, '0');
      const minutes = clock.minutes.toString().padStart(2, '0');
      const seconds = clock.seconds.toString().padStart(2, '0');
      const ampm = (clock.hours < 12) ? 'AM' : 'PM';
      const date = raw.toLocaleString(Qt.locale(), "ddd dd/MM/yy")
      return `${hours}:${minutes}:${seconds} ${ampm} | ${date}`
    }
  }
}
