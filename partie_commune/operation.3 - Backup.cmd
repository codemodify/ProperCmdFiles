
:createBackupFolders()
		:: make sure there is no backup made before this in the same session
		rmdir /S /Q "%siteBackupPath%" 1>nul 2>nul
		rmdir /S /Q "%dbBackupPath%" 1>nul 2>nul
		del /S /Q "%logFile%" 1>nul 2>nul
		
		:: clean and sweet
		mkdir "%siteBackupPath%"
		mkdir "%dbBackupPath%"

:doTheBackup()
		echo.
		call "operation.3 - Backup.Site.cmd"
		if %isError% == 1 goto :EOF

		echo.
		echo.
		call "operation.3 - Backup.DB.cmd"
