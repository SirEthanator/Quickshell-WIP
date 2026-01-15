ConfigCategory {
  category: "Notifications";

  property int width: 500;
  property int defaultTimeout: 5000;
  property int defaultCriticalTimeout: 8000;
  property int minimumTimeout: 2000;
  property int minimumCriticalTimeout: 4000;
  property bool sounds: true;
  property string normalSound: "/usr/share/sounds/ocean/stereo/message-new-instant.oga";
  property string criticalSound: "/usr/share/sounds/ocean/stereo/dialog-error-critical.oga";
  property int dismissThreshold: 30;
}
