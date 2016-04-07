
:siteInstallation()
		echo.
		echo "Installation de %siteSourcePath% -> %siteDestinationPath%"
		call controller.helper.echoString.cmd "En progress"
        call controller.helper.echoProgressBar.cmd

		iisweb /stop %siteName% 1>nul 2>nul
		:check1()
			if not errorlevel 0 goto check2()
			goto okToCopyFiles()
		:check2()
			if not errorlevel -2147024890 goto siteStopError()

		:okToCopyFiles()
		xcopy "%siteSourcePath%" "%siteDestinationPath%" /S /Q /Y /H 1>nul 2>nul

		REM ***     Gestion des erreurs de copie
		REM *** 0 - Copying was completed without error
		REM *** 1 - No files found
		REM *** 2 - User terminated the copy
		REM *** 4 - Initialization error (not enough memory, invalid syntax, path not found)
		REM *** 5 - Copy terminated due to INT 24 error reading or writing disk
		if ERRORLEVEL 5 goto siteInstallation5()
		IF ERRORLEVEL 4 GOTO siteInstallation4()
		IF ERRORLEVEL 2 GOTO siteInstallationError2()
		IF ERRORLEVEL 1 GOTO siteInstallationError1()
		IF ERRORLEVEL 0 GOTO siteInstallationOk()

		:siteInstallationError5()
				call controller.helper.echoString.cmd "FAIL"
				echo.
				echo Raison: Memoire insuffisante pour copier les fichiers ou lecteur non valide ou erreur de syntaxe.
                set isError=1
				goto :EOF

		:siteInstallationError4()
				call controller.helper.echoString.cmd "FAIL"
				echo.
				echo Raison: Erreur d'ecriture sur Disk : chemin non valide ou manque de memoire 
                set isError=1
				goto :EOF

		:siteInstallationError2()
				call controller.helper.echoString.cmd "FAIL"
				echo.
				echo Raison: Vous avez appuye sur CTRL+C pour annuler la copie.
                set isError=1
				goto :EOF

		:siteInstallationError1()
				call controller.helper.echoString.cmd "FAIL"
				echo.
				echo Raison: La source a copier n'a pas de contenu
                set isError=1
				goto :EOF

		:siteInstallationOk()
				call controller.helper.echoString.cmd "OK"
				iisweb /start %siteName% 1>nul 2>nul
				set isError=0
				goto :EOF


		:siteStopError()
				call controller.helper.echoString.cmd "FAIL"
				echo.
				echo Raison: Site stop error
                set isError=1
				goto :EOF

