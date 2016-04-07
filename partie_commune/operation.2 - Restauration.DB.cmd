
:dbRestauration()
		echo.
		echo "Restauration de BD %dbName% <- %dbBackupPath%"
		call controller.helper.echoString.cmd "En progress"
        call controller.helper.echoProgressBar.cmd
	
        echo RESTORE DATABASE %dbName% FROM DISK='%dbBackupPath%\%dbName%.bak' WITH REPLACE > restore.sql
        sqlcmd -s %dbServer% -U %dbUser% -P %dbPassword% -i restore.sql -o %logFile%

		call controller.helper.echoString.cmd "UNCONNUE"

		echo.
		echo __________________________________________________________________________
		echo Fichier de LOG de la sauvegarde de la base de données :
		type %logFile%
		echo __________________________________________________________________________

		set /P M=Taper 'A puis Entree' pour ARRETER, 'Entree' pour Continuer
		if %M%==A goto dbRestaurationError()
		IF %M%==a goto dbRestaurationError()
		
		goto dbRestaurationOk()

		:dbRestaurationError()
				echo.
				echo Echec du script en bas:
				type backup.sql
				set isError=1
				goto :EOF

		:dbRestaurationOk()
				set isError=0
