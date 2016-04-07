
:checkBackupPath()
        echo.
        call controller.helper.echoString.cmd "%backupPath%"
        call controller.helper.echoProgressBar.cmd
        if not exist "%backupPath%" goto checkBackupPathKo()
        goto checkBackupPathOk()

        :checkBackupPathKo()
                call controller.helper.echoString.cmd "FAIL"
                echo.
                echo Raison: Probleme d'access.
                set isError=1
                goto :EOF

        :checkBackupPathOk()
                call controller.helper.echoString.cmd "OK"

				mkdir "%backupPath%\%timeStamp%-%siteName%"
				mkdir "%siteBackupPath%"
				mkdir "%dbBackupPath%"

                set isError=0
