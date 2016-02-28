@ECHO OFF
      set deleteString=²ÔÑ×Í·Ïñ
      set listFile=list.tmp
      del "%listFile%" /q 1>nul 2>nul
      dir *.png /a /b>>"%listFile%"
      FOR /F "tokens=*" %%a IN (
      'more "%listFile%"'
      ) DO (
      SETLOCAL ENABLEDELAYEDEXPANSION
      set newFileName=%%a
      set newFileName=!newFileName:%deleteString%=!
      ren "%%a" "!newFileName!"
      ENDLOCAL
      )
      del "%listFile%" /q 1>nul 2>nul
      PAUSE