import "root:/";
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;

  required property Config page;
  required property var propName;
  required property var propValue;
  required property int index;
  required property int modelLen;
  required property var metadata;

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
        let props = {};
        switch (root.metadata.type) {
          case "bool":
            source = "Toggle.qml";
            break;
          default:
            return
        }
        setSource(source, { propName: root.propName, page: root.page });
        active = true;
      }
    }
  }
}

