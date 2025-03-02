import "root:/";
import "root:/utils";

SysStatMonitor {
  title: "Memory";
  percentage: SysInfo.memUsage;
  icon: "am-memory-symbolic";
}

