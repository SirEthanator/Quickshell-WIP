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

    ColumnLayout {
      Text {
        text: root.metadata.title;
        font {
          family: Globals.vars.fontFamily;
          pixelSize: Globals.vars.smallHeadingFontSize;
        }
        color: Globals.colours.fg;
      }
      Text {
        text: root.metadata.description;
        font {
          family: Globals.vars.fontFamily;
          pixelSize: Globals.vars.mainFontSize;
        }
        color: Globals.colours.grey;
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
        console.log(`${root.propName} ${root.metadata.type}`);
        setSource(source, { propName: root.propName, page: root.page });
        active = true;
      }
    }
  }
}

