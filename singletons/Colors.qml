pragma Singleton

import qs.singletons
import qs.singletons.modules.colors
import Quickshell;
import QtQuick;

Singleton {
  readonly property Scheme c: schemes[Conf.global.colorScheme];

  readonly property var schemes: ({ everforest, catMocha, rosePine, material });

  readonly property Scheme everforest: Everforest {}
  readonly property Scheme catMocha: CatMocha {}
  readonly property Scheme rosePine: RosePine {}
  readonly property Scheme material: Material {}
}
