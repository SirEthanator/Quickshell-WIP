pragma ComponentBehavior: Bound

import qs
import qs.utils as Utils
import QtQuick;
import Quickshell;
import Quickshell.Services.Mpris;

BarModule {
  id: root;
  icon: activePlayer.isPlaying ? "music-note-16th" : "media-playback-paused-symbolic";
  iconbgColour: Globals.colours.media;

  readonly property list<MprisPlayer> players: Utils.Mpris.players;
  readonly property MprisPlayer activePlayer: Utils.Mpris.activePlayer;

  show: !!activePlayer;

  Text {
    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }

    readonly property alias player: root.activePlayer;
    readonly property Scope posInfo: Utils.Mpris.posInfo;

    text: {
      const truncate = player.trackTitle.length > Globals.conf.bar.truncationLength;
      return `${truncate ? player.trackTitle.substring(0,Globals.conf.bar.truncationLength)+'...' : player.trackTitle}${player.positionSupported ? ' - ' + posInfo.posString : ''}`
    }
  }
}

