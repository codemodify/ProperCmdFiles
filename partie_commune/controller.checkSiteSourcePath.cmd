
:checkSiteSourcePath()
        echo.
        call controller.helper.echoString.cmd "%siteSourcePath%"
        call controller.helper.echoProgressBar.cmd
        net use q: /d >nul 2>nul
        net use q: %siteSourcePath% >nul 2>nul

        if errorlevel 53 if not errorlevel 54 goto checkSiteSourcePath53()
        if errorlevel 5  if not errorlevel 6  goto checkSiteSourcePath5()
        if errorlevel 0                       goto checkSiteSourcePathOk()

        :checkSiteSourcePath53()
                call controller.helper.echoString.cmd "FAIL"
                echo.
                echo Raison: Probleme de connexion ou erreur de syntaxe.
                set isError=1
                goto :EOF

        :checkSiteSourcePath5()
                call controller.helper.echoString.cmd "FAIL"
                echo.
                echo Raison: Probleme des droits.
                set isError=1
                goto :EOF

        :checkSiteSourcePathOk()
                call controller.helper.echoString.cmd "OK"
                net use q: /d >nul 2>nul
                set isError=0
