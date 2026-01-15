pragma Singleton

import qs.singletons.modules.scheme
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
  id: root;


  // =================
  // ==== Schemes ====
  // =================

  readonly property Scheme colours: schemes[Conf.global.colourScheme];

  readonly property var schemes: ({ everforest: everforest, catMocha: catMocha, rosePine: rosePine, material: material });

  readonly property Scheme everforest: Everforest {}
  readonly property Scheme catMocha: CatMocha {}
  readonly property Scheme rosePine: RosePine {}

  FileView {
    id: materialJson;
    path: Qt.resolvedUrl(Quickshell.shellPath("utils/material.json"));
    blockLoading: true;
    watchChanges: true;

    function setLoaderSrc() {
      // Does not work with an absolute path like Quickshell.shellPath("singletons/modules/scheme/Scheme.qml")
      materialSchemeLoader.setSource("modules/scheme/Scheme.qml", JSON.parse(text()));
    }

    Component.onCompleted: {
      setLoaderSrc();
    }

    onFileChanged: {
      reload();
      waitForJob();
      setLoaderSrc();
    }
  }

  Loader {
    id: materialSchemeLoader;
  }

  readonly property Scheme material: {
    if (materialSchemeLoader.status === Loader.Error || materialSchemeLoader.item === null) {
      return everforest  // Use Everforest as a fallback
    }
    return materialSchemeLoader.item as Scheme;
  }

  function alpha(color: color, opacity: real): color {
    return Qt.rgba(color.r, color.b, color.g, opacity)
  }

  // ================
  // ==== States ====
  // ================

  signal launchConfMenu;

  PersistentProperties {
    id: persist

    property bool menuOpen: false;
    property bool barHidden: false;
    property bool screensaverActive: false;
  }

  property alias states: persist;
}

