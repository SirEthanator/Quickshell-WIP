pragma ComponentBehavior: Bound

import "root:/";
import "root:/components";
import QtQuick;

OptionInput {
  id: root;

  property int max;
  property int min;

  valueParser: parseInt;

  field.validator: IntValidator {
    bottom: root.min;
    top: root.max;
  }
}

