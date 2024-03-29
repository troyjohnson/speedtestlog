# speedtestlog
Uses **speedtest-cli** to get connection speed data 
and logger to output it in a *Splunk-friendly* format.

Depends on having **speedtest-cli** installed here:
```
  /usr/bin/speedtest-cli
```
as well as having **logger** available here:
```
  /usr/bin/logger
```
works with the Ubuntu 20.04 **speedtest-cli** package.

Produces output to syslog similar to what appears below when functional:
```
Feb 22 09:30:36 myhostname SPEEDTEST: ping="32.036" ping_units="ms" download="18.75" download_units="Mbit/s" upload="3.51" upload_units="Mbit/s" version="0.3.4"
```
and something similar to this when an error occurs:
```
Feb 19 20:30:04 myhostname SPEEDTEST: error="true" notdefined="st_ping,st_p_units,st_download,st_dl_units,st_upload,st_ul_units"
```

There are a few searches that can easily pull this data together in Splunk:
```
"SPEEDTEST:" | stats avg(download)
"SPEEDTEST:" | stats avg(upload)
"SPEEDTEST:" | stats avg(ping)
"SPEEDTEST:" | timechart span=6h avg(ping) AS AveragePing avg(download) AS AverageDownload avg(upload) AS AverageUpload
```
