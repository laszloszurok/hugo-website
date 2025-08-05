---
title: "Linux Performance Analysis"
date: 2025-07-29T19:21:37+02:00
pagefind_index_page: true
---

src: https://netflixtechblog.com/linux-performance-analysis-in-60-000-milliseconds-accc10403c55

## Useful commands

```
uptime
dmesg | tail
vmstat 1
mpstat -P ALL 1
pidstat 1
iostat -xz 1
free -m
sar -n DEV 1
sar -n TCP,ETCP 1
```

### uptime

Quickly check uptime and load average.

### dmesg | tail

Quick glance at system messages.

### vmstat 1

Virtual memory stats. Arg '1' means print 1 second summaries.

### mpstat -P ALL 1

CPU time breakdowns per CPU.

### pidstat 1

Process summaries (similar to top, but does not clear the screen).

### iostat -xz 1

Disk usage stats.

### free -m

Memory usage stats.

### sar -n DEV 1

Network interface throughput stats.

### sar -n TCP, ETCP 1

Summary of TCP connection metrics.
