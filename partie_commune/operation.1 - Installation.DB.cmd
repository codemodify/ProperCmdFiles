
:checkIfAnyScriptsToExecute()
		if %anyScriptsToExecute% == 0 goto noDbOperations()
pause

:dbOperations()
		echo.
		echo "Installation / Mis a jour de BD %dbName%"

		echo %dbSourcePath%
		
		for %%a in (%dbSourcePath%\*.sql) do call controller.helper.execSqlFile.cmd %%a
		goto :EOF


:noDbOperations()
		set isError=0
	