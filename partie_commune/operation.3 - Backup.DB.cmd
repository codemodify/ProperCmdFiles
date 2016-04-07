
:dbBackup()
		echo.
		echo "Backup de BD %dbName% -> %dbBackupPath%"
		call controller.helper.echoString.cmd "En progress"
        call controller.helper.echoProgressBar.cmd
	
        echo BACKUP DATABASE %dbName% TO DISK='%dbBackupPath%\%dbName%.bak' > backup.sql
        sqlcmd -s %dbServer% -U %dbUser% -P %dbPassword% -i backup.sql -o %logFile%

		call controller.helper.echoString.cmd "UNCONNUE"

		echo.
		echo __________________________________________________________________________
		echo Fichier de LOG de la sauvegarde de la base de données :
		type %logFile%
		echo __________________________________________________________________________

		set /P M=Taper 'A puis Entree' pour ARRETER, 'Entree' pour Continuer
		if %M%==A goto dbBackupError()
		IF %M%==a goto dbBackupError()
		
		goto dbBackupOk()

		:dbBackupError()
				echo.
				echo Echec du script en bas:
				type backup.sql
				set isError=1
				goto :EOF

		:dbBackupOk()
				set isError=0
