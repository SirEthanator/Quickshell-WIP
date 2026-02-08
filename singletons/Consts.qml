pragma Singleton

import qs.singletons.modules.consts
import Quickshell;
import QtQuick;
import qs.utils as Utils;

Singleton {
  readonly property BarModules barModules: BarModules {}
  readonly property DashModules dashModules: DashModules {}

  readonly property WallpaperTypes wallpaperTypes: WallpaperTypes {}

  readonly property int gapSmall: gap / 2;
  readonly property int gap: Utils.Session.gap;  // Size of Hyprland/niri gap
  readonly property int gapLarge: gap + 8;

  readonly property int br: 6;  // Border Radius
  readonly property int brSmall: 2;

  readonly property real outlineSize: 1.5;

  readonly property string fontFamily: "Roboto Flex";
  readonly property int mainFontSize: 16;
  readonly property int largeFontSize: 64;
  readonly property int xlFontSize: 150;
  readonly property int headingFontSize: 34;
  readonly property int smallHeadingFontSize: 22;
  readonly property int mediumHeadingFontSize: 28;

  // This results in the modules' top and bottom padding matching paddingModule / 2 - relies on icons being the tallest items
  // Changes due to configuration are handled in Bar/Index
  readonly property int barHeight: moduleIconSize + paddingModule + paddingBar*2 + outlineSize*2;
  readonly property int paddingBar: 6;
  // Note that paddingModule will not directly affect the top and bottom padding. The top and bottom padding is based on the bar's height.
  readonly property int paddingModule: 8;
  readonly property int marginModule: 8;
  readonly property int moduleIconSize: 22;
  readonly property int wsSize: 7;

  readonly property int paddingWindow: 24;

  readonly property int paddingCard: 20;
  readonly property int marginCardSmall: 6;
  readonly property int marginCard: 10;

  readonly property int paddingButton: 10;
  readonly property int paddingButtonIcon: 8;
  readonly property int spacingButtonGroup: 3;

  readonly property int longAnimLen: 500;
  readonly property int animLen: 350;
  readonly property int transitionLen: 250;
  readonly property int shortTransitionLen: 150;

  readonly property int notifPopupSpacing: 10;
  readonly property int paddingNotif: paddingCard;
  readonly property int notifInnerSpacing: 10;

  readonly property int mainIconSize: 28;
  readonly property int largeIconSize: 34;
  readonly property int extraLargeIconSize: 90;

  readonly property color bgDimmedColour: "#4D000000";
  readonly property real disabledOpacity: 0.5;
}
