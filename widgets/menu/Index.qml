pragma ComponentBehavior: Bound

import qs.singletons
import qs.widgets.sidebar as Sidebar;
import qs.components
import "dashboard" as Dashboard;
import "launcher" as Launcher;
import QtQuick;
import QtQuick.Layouts;

Item {
  id: root;

  focus: true;

  anchors.fill: parent;

  Keys.onPressed: (event) => {
    if (!Sidebar.Controller.sidebarOpen) return;
    const key = event.key;
    if (key === Qt.Key_Tab && !event.isAutoRepeat) {
      stack.currentIndex++;
      appSearch.focus = false;
      focus = true;

    } else if ((key >= 48 && key <= 90) || (key >= 97 && key <= 122) || (key >= 186 && key <= 223)) {
      appSearch.field.insert(0, event.text);
      appSearch.focus = true;

    } else if (stack.currentIndex === 1) {
      if (key === Qt.Key_Return || key === Qt.Key_Enter) launcher.execSelected();
      if (key === Qt.Key_Down) launcher.down();
      if (key === Qt.Key_Up) launcher.up();
    }
  }

  ColumnLayout {
    id: content;
    spacing: Consts.paddingWindow;
    clip: true;

    anchors {
      fill: parent;
    }

    Input {
      id: appSearch;
      Layout.fillWidth: true;

      showBorder: Conf.sidebar.moduleOutlines;

      icon: "search-symbolic";

      field: InputField {
        placeholderText: "Search Applications";
        focusPolicy: Qt.ClickFocus;
        onFocusChanged: {
          if (focus) stack.currentIndex = 1
          else clear();
        }
      }
    }

    Stack {
      id: stack;
      Layout.fillHeight: true;
      Layout.fillWidth: true;
      wrapAround: true;

      Dashboard.Index {}
      Launcher.Index { id: launcher; searchText: appSearch.field.text }
    }

    PageIndicator { stack: stack }
  }
}
