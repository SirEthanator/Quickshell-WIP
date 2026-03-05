pragma Singleton

import Quickshell;

Singleton {
  function splitSeconds(totalSeconds: int): var {
    const h = Math.floor(totalSeconds / 3600);
    const m = Math.floor((totalSeconds % 3600) / 60);
    const s = totalSeconds % 60;

    return { h, m, s }
  }

  function colonSeparated(totalSeconds: int, hideSeconds: bool): string {
    let { h, m, s } = splitSeconds(totalSeconds);
    h = h.toString().padStart(2, '0');
    m = m.toString().padStart(2, '0');
    s = s.toString().padStart(2, '0');
    let result = "";

    // Hide hours if 0
    if (h > 0) {
      result += `${h}:`;
    }

    // Always have minutes
    result += `${m}`;

    // Always have seconds unless hidden
    if (!hideSeconds) {
      result += `:${s}`;
    }

    return result;
  }

  function letters(totalSeconds: int, hideSeconds: bool): string {
    const { h, m, s } = splitSeconds(totalSeconds);
    let result = "";

    if (h > 0) {
      result += `${h}h `;
    }
    result += `${m}m`;
    if (!hideSeconds) {
      result += ` ${s}s`;
    }
    return result;
  }
}
