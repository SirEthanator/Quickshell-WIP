import "..";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  color: Opts.colours.bgLight;
  topRightRadius: ! Opts.bar.floating && Opts.bar.floatingModules ? 0 : Opts.vars.br;
  topLeftRadius: ! Opts.bar.floating && Opts.bar.floatingModules ? 0 : Opts.vars.br;
  bottomLeftRadius: Opts.vars.br;
  bottomRightRadius: Opts.vars.br;
  Layout.fillHeight: true
}

