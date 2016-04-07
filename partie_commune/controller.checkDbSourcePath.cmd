
:checkDbSourcePath()
        echo.
        call controller.helper.echoString.cmd "%dbSourcePath%"
        call controller.helper.echoProgressBar.cmd
        if not exist "%dbSourcePath%\*.*" goto checkDbSourcePathKo()		
		
        goto checkDbSourcePathOk()

        :checkDbSourcePathKo()
                call controller.helper.echoString.cmd "FAIL"
                echo.
                echo Raison: Probleme d'access. Donc pas des scripts SQL pour execution
                set isError=0
				set anyScriptsToExecute=0
                goto :EOF

        :checkDbSourcePathOk()
                call controller.helper.echoString.cmd "OK"
                set isError=0
				set anyScriptsToExecute=1
