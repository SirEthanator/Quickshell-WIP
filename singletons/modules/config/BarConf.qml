ConfigCategory {
  category: "Bar";

  property list<string> left: [
    "menu",
    "workspaces",
    "activeWindow"
  ];
  property list<string> centre: ["dateAndTime"];
  property list<string> right: [
    "tray",
    "network",
    "battery",
    "media",
    "volume"
  ];
  property bool autohide: false;
  property bool docked: false;
  property bool floatingModules: false;
  property bool multiColourModules: false;
  property bool moduleOutlines: false;
  property bool backgroundOutline: true;
  property int workspaceCount: 10;
  property int truncationLength: 60;
}
