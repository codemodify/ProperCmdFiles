
:siteBackup()
		echo.
		echo "Backup de %siteDestinationPath% -> %siteBackupPath%"
		call controller.helper.echoString.cmd "En progress"
        call controller.helper.echoProgressBar.cmd

		xcopy "%siteDestinationPath%" "%siteBackupPath%" /S /Q /Y /H 1>nul 2>nul

		REM ***     Gestion des erreurs de copie
		REM *** 0 - Copying was completed without error
		REM *** 1 - No files found
		REM *** 2 - User terminated the copy
		REM *** 4 - Initialization error (not enough memory, invalid syntax, path not found)
		REM *** 5 - Copy terminated due to INT 24 error reading or writing disk
		if errorlevel 5 goto siteBackupError5()
		IF ERRORLEVEL 4 GOTO siteBackupError4()
		IF ERRORLEVEL 2 GOTO siteBackupError2()
		IF ERRORLEVEL 1 GOTO siteBackupError1()
		IF ERRORLEVEL 0 GOTO siteBackupOk()

		:siteBackupError5()
				call controller.helper.echoString.cmd "FAIL"
				echo.
				echo Raison: Memoire insuffisante pour copier les fichiers ou lecteur non valide ou erreur de syntaxe.
                set isError=1
				goto :EOF

		:siteBackupError4()
				call controller.helper.echoString.cmd "FAIL"
				echo.
				echo Raison: Erreur d'ecriture sur Disk : chemin non valide ou manque de memoire 
                set isError=1
				goto :EOF

		:siteBackupError2()
				call controller.helper.echoString.cmd "FAIL"
				echo.
				echo Raison: Vous avez appuye sur CTRL+C pour annuler la copie.
                set isError=1
				goto :EOF

		:siteBackupError1()
				call controller.helper.echoString.cmd "FAIL"
				echo.
				echo Raison: La source a copier n'a pas de contenu
                set isError=1
				goto :EOF

		:siteBackupOk()
				call controller.helper.echoString.cmd "OK"
				set isError=0
