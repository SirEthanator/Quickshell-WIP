pragma ComponentBehavior: Bound

import QtQuick;

OptionInput {
  id: root;

  property alias max: validator.top;
  property alias min: validator.bottom;

  valueParser: parseInt;

  field.validator: IntValidator {
    id: validator;
  }
}

