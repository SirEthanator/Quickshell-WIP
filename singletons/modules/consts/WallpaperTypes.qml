import QtQuick;
import qs.utils as Utils;

QtObject {
  id: root;

  readonly property WallpaperType regular: WallpaperType { title: "Static" }
  readonly property WallpaperType video: WallpaperType { title: "Video" }
  readonly property WallpaperType slideshow: WallpaperType { title: "Slideshow" }
  readonly property WallpaperType hidden: WallpaperType { title: "Hidden" }

  function toStripped(): var {
    return Utils.StripMeta.stripMeta(root);
  }
}
