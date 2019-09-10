@rem 清除之前的log
C:\Users\admin\AppData\Local\Android\Sdk\platform-tools\adb.exe logcat -c
@rem 启动logcat输出，过滤
@rem C:\Users\admin\AppData\Local\Android\Sdk\platform-tools\adb.exe logcat -s Unity | find "["
C:\Users\admin\AppData\Local\Android\Sdk\platform-tools\adb.exe logcat -s Unity