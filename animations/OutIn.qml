import QtQuick;

Behavior {
  id: root

  property QtObject fadeTarget: targetProperty.object;
  property string fadeProperty: "opacity";
  property int fadeDuration: 100;
  property int fadeOutDuration: fadeDuration;
  property int fadeInDuration: fadeDuration;
  property var fadeValue: 0;
  property string easingType: "Linear";
  required property var originalValue;  // Could be done using target[property] but if exitAnimation stops early it will become fadeValue

  property alias exitAnimation: exitAnimation;
  property alias enterAnimation: enterAnimation;

  SequentialAnimation {
    NumberAnimation {
      id: exitAnimation
      target: root.fadeTarget;
      property: root.fadeProperty;
      duration: root.fadeOutDuration;
      to: root.fadeValue;
      easing.type: Easing[root.easingType];
    }
    PropertyAction { }
    NumberAnimation {
      id: enterAnimation
      target: root.fadeTarget;
      property: root.fadeProperty;
      duration: root.fadeInDuration;
      to: root.originalValue;
      easing.type: Easing[root.easingType];
    }
  }
}
