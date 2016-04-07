
:checkDbDestinationPath()
        echo.
        call controller.helper.echoString.cmd "%dbDestinationPath%"
        call controller.helper.echoProgressBar.cmd
        if not exist "%dbDestinationPath%" goto checkDbDestinationPathKo()
        goto checkDbDestinationPathOk()

        :checkDbDestinationPathKo()
                call controller.helper.echoString.cmd "FAIL"
                echo.
                echo Raison: Probleme d'access.
                set isError=1
                goto :EOF

        :checkDbDestinationPathOk()
                call controller.helper.echoString.cmd "OK"
                set isError=0
