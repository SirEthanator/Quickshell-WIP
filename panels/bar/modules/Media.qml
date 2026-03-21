pragma ComponentBehavior: Bound

import qs.singletons
import qs.panels.bar
import qs.widgets.media as Media;
import qs.utils as Utils
import QtQuick;
import Quickshell.Services.Mpris;

BarModule {
  id: root;
  icon: activePlayer.isPlaying ? "music-note-16th" : "media-playback-paused-symbolic";
  iconbgColor: Colors.c.media;

  readonly property list<MprisPlayer> players: Utils.Mpris.players;
  readonly property MprisPlayer activePlayer: Utils.Mpris.activePlayer;

  show: !!activePlayer;

  Text {
    color: Colors.c.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }

    readonly property alias player: root.activePlayer;
    readonly property string posString: Utils.Mpris.posInfo.posString;

    text: {
      const truncate = player.trackTitle.length > Conf.bar.truncationLength;
      return `${truncate ? player.trackTitle.substring(0,Conf.bar.truncationLength)+'...' : player.trackTitle}${player.positionSupported ? ' - ' + posString : ''}`
    }
  }

  tooltip: Tooltip {
    Text {
      text: `${root.activePlayer.isPlaying ? "" : "[Paused] - "}Now playing "${root.activePlayer.trackTitle}" by ${root.activePlayer.trackArtist || "unknown artist"}`;
      color: Colors.c.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }

  menu: Tooltip {
    padding: 0;
    disableOutline: true;

    Media.Index {}
  }
}
