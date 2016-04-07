
:: Input
::		%1 - fullPathToSqlFile
:: ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

:: check if there are any previous errors
if %isError% == 1 goto :EOF

set fullPathToSqlFile=%1


:execSqlFile()

		echo.
		echo "Execution SQL %fullPathToSqlFile%
		call controller.helper.echoString.cmd "En progress"
		call controller.helper.echoProgressBar.cmd

		sqlcmd -s %dbServer% -U %dbUser% -P %dbPassword% -i "%fullPathToSqlFile%" -o %logFile%

		:dbResultCheck()
				call controller.helper.echoString.cmd "UNCONNUE"
				echo.
				echo ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
				echo Fichier LOG de l'execution SQL
				echo ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
				type %logFile%
				echo __________________________________________________________________________

				set /P M=Taper 'A puis Entree' pour ARRETER, 'Entree' pour Continuer
				if %M%==A goto dbOperationsError()
				IF %M%==a goto dbOperationsError()

				goto dbOperationsOk()

				:dbOperationsError()
						echo.
						echo Echec d'operation SQL
						set isError=1
						goto :EOF

		:dbOperationsOk()
				set isError=0
