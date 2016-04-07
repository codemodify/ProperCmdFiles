
:checkBackupFolders()
		
		if not exist "%siteBackupPath%" goto noSiteBackupFound()
		if not exist "%dbBackupPath%" goto noDBBackupFound()

		goto doTheRestore()
		
		:noSiteBackupFound()
				echo.
				echo Il manque le backup de site.
				set isError=1
				goto :EOF

		:noDBBackupFound()
				echo.
				echo Il manque le backup de BD.
				set isError=1
				goto :EOF


:doTheRestore()
		echo.
		call "operation.2 - Restauration.Site.cmd"
		if %isError% == 1 goto :EOF

		echo.
		echo.
		call "operation.2 - Restauration.DB.cmd"
