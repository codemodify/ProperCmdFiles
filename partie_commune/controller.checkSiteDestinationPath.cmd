
:checkSiteDestinationPath()
        echo.
        call controller.helper.echoString.cmd "%siteDestinationPath%"
        call controller.helper.echoProgressBar.cmd
        if not exist "%siteDestinationPath%" goto checkSiteDestinationPathKo()
        goto checkSiteDestinationPathOk()

        :checkSiteDestinationPathKo()
                call controller.helper.echoString.cmd "FAIL"
                echo.
                echo Raison: Probleme d'access.
                set isError=1
                goto :EOF

        :checkSiteDestinationPathOk()
                call controller.helper.echoString.cmd "OK"
                set isError=0
