pragma ComponentBehavior: Bound

import qs
import QtQuick;
import Quickshell;
import Quickshell.Services.Mpris;

BarModule {
  id: root;
  icon: activePlayer.isPlaying ? "music-note-16th" : "media-playback-paused-symbolic";
  iconbgColour: Globals.colours.media;

  property list<MprisPlayer> players: Mpris.players.values;
  readonly property MprisPlayer activePlayer: players[0];

  show: !!activePlayer;

  function sortPlayers() {
    players.sort((a,b) => {
      if (a.isPlaying && !b.isPlaying) return -1;
      if (!a.isPlaying && b.isPlaying) return 1;
      return 0;
    })
  }

  Component.onCompleted: sortPlayers();

  Instantiator {
    model: root.players;

    Connections {
      required property MprisPlayer modelData;
      target: modelData;

      function onIsPlayingChanged() { root.sortPlayers() }
      Component.onDestruction: root.sortPlayers();
      Component.onCompleted: root.sortPlayers();
    }
  }

  Text {
    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }

    readonly property alias player: root.activePlayer;
    readonly property Scope posInfo: Scope {
      id: posInfo;
      property int position: Math.floor(root.activePlayer.position);
      property int length: Math.floor(root.activePlayer.length);
      FrameAnimation {
        id: posTracker;
        running: root.visible && root.activePlayer.positionSupported && root.activePlayer.isPlaying;
        onTriggered: root.activePlayer.positionChanged();
      }

      function timeString(time: int): string {
        const seconds = time % 60;
        const minutes = Math.floor(time / 60);
        return `${minutes}:${seconds.toString().padStart(2, '0')}`
      }
      property string posString: `${timeString(position)}/${timeString(length)}`
    }

    text: {
      const truncate = player.trackTitle.length > Globals.conf.bar.truncationLength;
      return `${truncate ? player.trackTitle.substring(0,Globals.conf.bar.truncationLength)+'...' : player.trackTitle}${player.positionSupported ? ' - ' + posInfo.posString : ''}`
    }
  }
}

