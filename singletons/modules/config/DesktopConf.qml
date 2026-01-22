import QtQuick;

ConfigCategory {
  category: "Desktop";

  property string wallpaper: "";
  property bool backdropWallpaper: false;
  property string wallpaperType: "regular";
  property int fadeSpeed: 2000;
  property string shader: "";
  property color bgColour: "black";

  property int slideshowInterval: 30;
}
