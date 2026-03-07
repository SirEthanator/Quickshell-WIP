pragma Singleton

import qs.singletons
import qs.singletons.modules.scheme
import Quickshell;
import QtQuick;

Singleton {
  id: root;

  readonly property Scheme colors: schemes[Conf.global.colorScheme];

  readonly property var schemes: ({ everforest: everforest, catMocha: catMocha, rosePine: rosePine, material: material });

  readonly property Scheme everforest: Everforest {}
  readonly property Scheme catMocha: CatMocha {}
  readonly property Scheme rosePine: RosePine {}
  readonly property Scheme material: Material {}

  signal launchConfMenu;

  PersistentProperties {
    id: persist

    property bool screensaverActive: false;
  }

  property alias states: persist;
}
