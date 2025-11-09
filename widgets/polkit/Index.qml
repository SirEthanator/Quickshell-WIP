pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.animations as Anims;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;

Scope {
  Polkit {
    id: polkit;
    onIsActiveChanged: {
      if (isActive) loader.open = true;
    }
  }

  Connections {
    target: polkit.flow;

    function onFailedChanged() {
      polkit.isAuthenticating = false;
    }
    function onIsSuccessfulChanged() {
      polkit.isAuthenticating = false;
    }
  }

  LazyLoader {
    id: loader;
    activeAsync: false;

    property bool open: false;

    onOpenChanged: {
      if (open) activeAsync = true;
    }

    PanelWindow {
      id: root;
      color: "transparent";

      anchors {
        top: true;
        bottom: true;
        left: true;
        right: true;
      }

      exclusionMode: Globals.conf.polkit.hideApplications ? ExclusionMode.Ignore : ExclusionMode.Normal;
      WlrLayershell.layer: WlrLayer.Overlay;
      WlrLayershell.keyboardFocus: loader.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None;

      Loader {
        id: wallpaperLoader;
        anchors.fill: parent;
        active: Globals.conf.polkit.hideApplications;
        source: Quickshell.shellPath("widgets/desktop/Wallpaper.qml");
      }

      Rectangle {
        anchors.fill: parent;
        color: Globals.vars.bgDimmedColour;
        visible: Globals.conf.polkit.dimBackground;
      }

      ParallelAnimation {
        running: loader.open;

        Anims.NumberAnim {
          target: wallpaperLoader.item;
          property: "opacity";
          from: 0; to: 1;
          duration: Globals.vars.animLen;
        }
        Anims.Slide {
          target: wrapper;
          grow: true;
          slideOffset: 200;
        }
      }

      SequentialAnimation {
        running: !loader.open;

        ParallelAnimation {
          Anims.NumberAnim {
            target: wallpaperLoader.item;
            property: "opacity";
            from: 1; to: 0;
            duration: Globals.vars.animLen;
          }
          Anims.Slide {
            target: wrapper;
            reverse: true;
          }
        }

        PropertyAction {
          target: loader;
          property: "activeAsync";
          value: false;
        }
      }

      Connections {
        target: polkit.flow;

        function onIsCompletedChanged() {
          if (polkit.flow.isCompleted) loader.open = false;
        }

        function onIsCancelledChanged() {
          if (polkit.flow.isCancelled) loader.open = false;
        }
      }

      Item {
        id: wrapper;
        width: Globals.conf.menu.width + Globals.vars.gapLarge * 2;
        height: parent.height;
        focus: true;

        Keys.onPressed: (event) => {
          if (!loader.open) return;
          const key = event.key;

          if (key === Qt.Key_Escape) {
            polkit.flow.cancelAuthenticationRequest();
            loader.open = false;
          }
        }

        Shadow { target: background }

        OutlinedRectangle {
          id: background;

          anchors {
            fill: parent;
            margins: Globals.vars.gapLarge;
          }

          color: Globals.colours.bg;
          radius: Globals.vars.br;

          disableAllOutlines: !Globals.conf.polkit.backgroundOutline;
        }

        Item {
          id: content;
          anchors.fill: background;
          anchors.margins: Globals.vars.paddingWindow;

          ColumnLayout {
            id: mainColumn;
            anchors.centerIn: parent;
            width: parent.width;
            spacing: Globals.vars.paddingWindow * 2;

            RowLayout {
              spacing: Globals.vars.paddingWindow;
              Layout.fillWidth: true;

              Icon {
                size: 64;
                icon: polkit.flow.iconName;
                fallback: "gtk-dialog-authentication";
                isMask: false;
              }

              ColumnLayout {
                spacing: Globals.vars.marginCard;

                Text {
                  Layout.fillWidth: true;
                  text: polkit.flow.message;
                  color: Globals.colours.fg;
                  font {
                    family: Globals.vars.fontFamily;
                    pixelSize: Globals.vars.smallHeadingFontSize;
                  }
                  wrapMode: Text.Wrap;
                }

                Text {
                  text: "An application is attempting to perform an action requiring elevated permissions. Authentication is required.";
                  Layout.fillWidth: true;
                  color: Globals.colours.grey;
                  font {
                    family: Globals.vars.fontFamily;
                    pixelSize: Globals.vars.mainFontSize;
                  }
                  wrapMode: Text.Wrap;
                }

              }
            }

            PassInput { polkit: polkit }
          }

          Button {
            anchors {
              right: parent.right;
              top: mainColumn.bottom;
              topMargin: Globals.vars.marginCard;
            }

            label: "Cancel";

            allRadius: true;
            bg: Globals.colours.bgLight;

            onClicked: {
              polkit.flow.cancelAuthenticationRequest();
              loader.open = false;
            }
          }

          Status {
            polkit: polkit;
          }
        }
      }
    }
  }
}
