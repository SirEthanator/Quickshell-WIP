pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell;
import Quickshell.Services.Mpris;
import QtQuick;

Singleton {
  id: root;

  property list<MprisPlayer> players: Mpris.players.values;
  readonly property MprisPlayer activePlayer: players[0];

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

  readonly property var posInfo: Scope {
    id: posInfo;
    property int position: Math.floor(root.activePlayer.position);
    property int length: Math.floor(root.activePlayer.length);

    Timer {
      id: posTracker;
      running: root.activePlayer.positionSupported && root.activePlayer.isPlaying;
      repeat: true;
      interval: 1000;
      onTriggered: root.activePlayer.positionChanged();
    }

    function timeString(time: int): string {
      const seconds = time % 60;
      const minutes = Math.floor(time / 60);
      return `${minutes}:${seconds.toString().padStart(2, '0')}`
    }
    property string positionString: timeString(position);
    property string lengthString: timeString(length);
    property string posString: `${positionString}/${lengthString}`;
  }
}

