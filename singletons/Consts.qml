pragma Singleton

import qs.singletons.modules.consts
import Quickshell;
import QtQuick;
import qs.utils as Utils;

Singleton {
  id: root;

  readonly property BarModules barModules: BarModules {}
  readonly property DashModules dashModules: DashModules {}

  readonly property WallpaperTypes wallpaperTypes: WallpaperTypes {}

  readonly property int gapSmall: gap / 2;
  readonly property int gap: Utils.Session.gap;  // Size of Hyprland/niri gap
  readonly property int gapLarge: gap + 8;

  // Border radii
  readonly property int br: 6;
  readonly property int brSmall: 2;

  readonly property real outlineSize: 1.5;

  readonly property int paddingXSmall: 6;
  readonly property int paddingSmall: 8;
  readonly property int paddingMedium: 10;
  readonly property int paddingMedLarge: 12;
  readonly property int paddingLarge: 14;
  readonly property int paddingWindow: 18;

  readonly property alias paddingBar: root.paddingXSmall;
  readonly property alias paddingButton: root.paddingMedium;
  readonly property alias paddingButtonIcon: root.paddingSmall;
  readonly property int spacingButtonGroup: 3;

  readonly property string fontFamMain: "Roboto Flex";
  readonly property string fontFamMono: "Roboto Mono";

  readonly property int fontSizeMain: 16;
  readonly property int fontSizeMedium: 18;
  readonly property int fontSizeSmallLarge: 22;
  readonly property int fontSizeMedLarge: 28;
  readonly property int fontSizeLarge: 34;
  readonly property int fontSizeXLarge: 64;

  readonly property int iconSizeSmall: 22;
  readonly property int iconSizeMain: 28;
  readonly property int iconSizeLarge: 34;
  readonly property int iconSizeXLarge: 90;

  // This results in the modules' top and bottom padding matching half of paddingSmall.
  // This relies on icons being the tallest items.
  // Changes from configuration are handled in Bar/Index.
  readonly property int barHeight: iconSizeSmall + paddingSmall + paddingBar*2 + outlineSize*2;
  readonly property int wsSize: 7;

  readonly property int animLenMain: 350;
  readonly property int transitionLenMain: 250;
  readonly property int transitionLenShort: 150;

  readonly property int progressBarHeight: 5;

  readonly property real disabledOpacity: 0.5;
}
