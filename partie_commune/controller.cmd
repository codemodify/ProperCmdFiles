
rem Some internal variables
rem ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
:prepareInternalVariables()
		set isError=0
		set anyScriptsToExecute=0

		set yyyy=%date:~-4,4%
		set mm=%date:~-7,2%
		set dd=%date:~-10,2%

		set hh=%time:~0,2%
		set mm=%time:~3,2%
		set ss=%time:~6,2%
        
		set timeStamp=%yyyy%-%mm%-%dd%-%hh%-%mm%-%ss%
		set backupFolderName=%backupPath%\%timeStamp%-%siteName%

		rem mis a jour des variables pour la periode de backup ou restore
		set siteBackupPath=%backupFolderName%\site
		set dbBackupPath=%backupFolderName%\db
		set logFile="%backupFolderName%\log.log"


:begin()
	    cls
	    echo. 
	    echo ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	    echo    Debut de la procedure d'installation 
	    echo ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	    echo. 
	    echo Verification de parametrage
	    
	    call controller.checkSiteSourcePath.cmd
	    if %isError% == 1 goto end()

	    call controller.checkSiteDestinationPath.cmd
	    if %isError% == 1 goto end()

	    call controller.checkDbSourcePath.cmd
	    if %isError% == 1 goto end()

	    call controller.checkDbDestinationPath.cmd
	    if %isError% == 1 goto end()		
		
	    call controller.checkBackupPath.cmd
	    if %isError% == 1 goto end()

rem	    call controller.checkTempFolder.cmd
rem	    if %isError% == 1 goto end()

	    call controller.showMenu.cmd
    
:end()
	    echo.
	    echo.
	    echo.
	    echo ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	    echo    Fin de la procedure d'installation
	    echo ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	    echo.
	    pause
