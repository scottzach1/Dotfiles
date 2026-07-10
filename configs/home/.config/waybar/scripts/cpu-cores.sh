#!/bin/sh
# Per-core CPU load sparkline for waybar — recreates polybar's ramp-coreload.
# Emits one block glyph per logical core, scaled by that core's utilisation
# since the previous call. The previous /proc/stat snapshot is cached so we
# never block-sleep; waybar's `interval` provides the sampling window.
cache="${XDG_RUNTIME_DIR:-/tmp}/waybar-cpu-cores.$(id -u)"

awk -v cache="$cache" '
BEGIN {
  n = split("▁ ▂ ▃ ▄ ▅ ▆ ▇ █", bar, " ")     # split handles multibyte glyphs as whole fields
  while ((getline line < cache) > 0) {
    split(line, f, " "); pt[f[1]] = f[2]; pi[f[1]] = f[3]
  }
  close(cache)
}
/^cpu[0-9]+ / {
  core = $1
  total = 0
  for (i = 2; i <= NF; i++) total += $i
  idle = $5 + $6                               # idle + iowait
  dt = total - pt[core]; di = idle - pi[core]
  u = (dt > 0) ? 1 - di / dt : 0
  if (u < 0) u = 0; else if (u > 1) u = 1
  out = out bar[int(u * (n - 1) + 0.5) + 1]
  snap = snap core " " total " " idle "\n"
}
END {
  printf "%s\n", out
  printf "%s", snap > cache
}
' /proc/stat
