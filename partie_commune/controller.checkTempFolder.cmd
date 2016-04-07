
:removeTempFolder()
        echo.
        call controller.helper.echoString.cmd "%tempFolder%"
        call controller.helper.echoProgressBar.cmd
        rmdir /S /Q %tempFolder% >nul 2>nul
        rmdir /S /Q %tempFolder% >nul 2>nul
        
        if errorlevel 0 goto removeTempFolderOk()
        call controller.helper.echoString.cmd "FAIL"
        echo.
        echo Raison: Probleme de suppression.
        set isError=1
        goto :EOF

        :removeTempFolderOk()
                call controller.helper.echoString.cmd "OK"
                mkdir %tempFolder%
                set isError=0
