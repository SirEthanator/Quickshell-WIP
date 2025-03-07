import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Services.Pipewire;

BarModule {
  id: root;
  readonly property PwNode node: Pipewire.defaultAudioSink;
  PwObjectTracker { objects: [ root.node ] }

  readonly property int volume: Math.round(root.node?.audio.volume * 100);

  icon: {
    if (root.node?.audio.muted ) { return "audio-volume-muted-panel-symbolic"  } else
    if (root?.volume >= 90     ) { return "audio-volume-high-danger-symbolic"  } else
    if (root?.volume >= 60     ) { return "audio-volume-high-panel-symbolic"   } else
    if (root?.volume >= 30     ) { return "audio-volume-medium-panel-symbolic" } else
    if (root?.volume >= 1      ) { return "audio-volume-low-panel-symbolic"    }
    else { return "audio-volume-muted-panel-symbolic" };
  }
  iconbgColour: Globals.colours.volume;

  Text {
    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }
    text: `${root.volume}%`;
  }
}

