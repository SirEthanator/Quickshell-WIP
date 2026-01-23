import qs.singletons
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;

  required property string page;
  required property string section;
  required property var propName;
  required property int index;
  required property int modelLen;

  readonly property var metadata: Conf.metadata[page][section][propName];

  implicitHeight: content.height + Consts.paddingCard*2;
  Layout.fillWidth: true;

  color: Globals.colours.bgLight;
  topLeftRadius: index === 0 ? Consts.br : 0; topRightRadius: topLeftRadius;
  bottomLeftRadius: index === modelLen-1 ? Consts.br : 0; bottomRightRadius: bottomLeftRadius;

  // If this option is displaying a popup, we want to make sure that popup is fully visible
  // To do this, we set this option's z index to one higher than the rest of the options,
  // so that it and, more importantly, its children display on top.
  z: (!!valueLoader.item && !!valueLoader.item.popupOpen) ? 1000
    : (!!longValueLoader.item && !!longValueLoader.item.popupOpen) ? 1000
    : 0;

  RowLayout {
    id: content;
    anchors.top: parent.top;
    anchors.left: parent.left;
    anchors.right: parent.right;
    anchors.margins: Consts.paddingCard;

    spacing: longValueLoader.active ? 0 : Consts.paddingCard;

    ColumnLayout {
      Layout.maximumWidth: content.width - valueLoader.width - content.spacing;
      spacing: Consts.marginCard;

      ColumnLayout {
        spacing: Consts.marginCardSmall;
        Text {
          text: root.metadata.title;
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.smallHeadingFontSize;
          }
          color: Globals.colours.fg;

          Layout.fillWidth: true;
          maximumLineCount: 1;
          elide: Text.ElideRight;
        }
        Text {
          text: root.metadata.description;
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.mainFontSize;
          }
          color: Globals.colours.grey;

          Layout.fillWidth: true;
          wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
        }
      }

      Loader {
        id: longValueLoader;
        Layout.fillWidth: true;
        Layout.preferredHeight: (!!item && !!item.implicitHeight) ? item.implicitHeight : 0;

        active: false;
        visible: active;

        Component.onCompleted: {
          let source = "";
          let props = {
            page: root.page,
            propName: root.propName,
          }

          if (root.metadata.type === "path") {
            source = "PathInput.qml";
            props = Object.assign(props, {
              allowEmpty: root.metadata.allowEmpty ?? false,
              metadata: root.metadata
            })
          } else if (root.metadata.type.match(/^list<[A-z]*>$/g)) {
            source = "ListInput.qml";
            props = Object.assign(props, { options: root.metadata.options });
          }

          if (source !== "") {
            setSource(source, props);
            active = true;
          }
        }
      }
    }

    Loader {
      id: valueLoader;
      Layout.preferredHeight: (!!item && !!item.height) ? item.height : 0;
      Layout.preferredWidth: (!!item && !!item.width) ? item.width : 0;
      Layout.alignment: Qt.AlignRight;

      active: false;
      visible: active;

      Component.onCompleted: {
        let source = "";
        let props = {
          page: root.page,
          propName: root.propName,
        }
        let show = true;

        switch (root.metadata.type) {
          case "bool":
            source = "Toggle.qml";
            break;

          case "string":
            if (!!root.metadata.options) {
              source = "Dropdown.qml";
              props = Object.assign(props, { options: root.metadata.options })
            } else {
              source = "StringInput.qml";
            }
            break;

          case "int":
            source = "IntInput.qml";
            props = Object.assign(props, { max: root.metadata.max, min: root.metadata.min })
            break;
        }

        if (source !== "") {
          setSource(source, props);
          active = true;
        }
      }
    }
  }
}

