@echo off

      set listFile=list.tmp
      del "%listFile%" /q 1>nul 2>nul
      dir /od *.png /a /b>>"%listFile%"
      FOR /F "tokens=*" %%a IN (
      'more "%listFile%"'
      ) DO (
      SETLOCAL ENABLEDELAYEDEXPANSION
      set /a "newFileName=%%~na-1"
	 echo !newFileName!
	 copy "%%a" "./h/!newFileName!.png"
      ENDLOCAL
      )
      del "%listFile%" /q 1>nul 2>nul

      PAUSE