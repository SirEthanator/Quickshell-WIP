import "root:/";
import "root:/utils";

SysStatMonitor {
  title: "CPU";
  percentage: SysInfo.cpuUsage;
  icon: "am-cpu-symbolic";
}

