import "root:/";
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;

  required property var controller;
  required property string page;
  required property var propName;
  required property int index;
  required property int modelLen;

  readonly property var propValue: Globals.conf[page][propName];
  readonly property var metadata: Globals.conf[page].getMetadata(propName);

  height: content.height + Globals.vars.paddingCard*2;
  width: parent.width;

  color: Globals.colours.bgLight;
  topLeftRadius: index === 0 ? Globals.vars.br : 0; topRightRadius: topLeftRadius;
  bottomLeftRadius: index === modelLen-1 ? Globals.vars.br : 0; bottomRightRadius: bottomLeftRadius;

  RowLayout {
    id: content;
    anchors.top: parent.top;
    anchors.left: parent.left;
    anchors.right: parent.right;
    anchors.margins: Globals.vars.paddingCard;

    spacing: Globals.vars.paddingCard;

    ColumnLayout {
      Layout.maximumWidth: content.width - valueLoader.width - content.spacing;

      Text {
        text: root.metadata.title;
        font {
          family: Globals.vars.fontFamily;
          pixelSize: Globals.vars.smallHeadingFontSize;
        }
        color: Globals.colours.fg;

        Layout.fillWidth: true;
        maximumLineCount: 1;
        elide: Text.ElideRight;
      }
      Text {
        text: root.metadata.description;
        font {
          family: Globals.vars.fontFamily;
          pixelSize: Globals.vars.mainFontSize;
        }
        color: Globals.colours.grey;

        Layout.fillWidth: true;
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
      }
    }

    Loader {
      id: valueLoader;
      Layout.preferredHeight: item.height;
      Layout.preferredWidth: item.width;
      Layout.alignment: Qt.AlignRight;

      Component.onCompleted: {
        let source = "";
        let props = { propName: root.propName, page: root.page, controller: root.controller };

        switch (root.metadata.type) {
          case "bool":
            source = "Toggle.qml";
            break;

          case "string":
            if (!!root.metadata.options) {
              source = "Dropdown.qml";
              props = Object.assign(props, { options: root.metadata.options })
            } else return;
            break;

          case "int":
            source = "IntInput.qml";
            props = Object.assign(props, { max: root.metadata.max, min: root.metadata.min })
            break;

          default:
            return
        }

        setSource(source, props);
        active = true;
      }
    }
  }
}

