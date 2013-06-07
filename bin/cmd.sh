# 获取 flv fps
mplayer -vo null -ao null -frames 0 -msglevel all=-1:identify=4 312768.flv 2>/dev/null | grep FPSID_VIDEO_FPS=29.970
