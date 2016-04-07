

:doInstall()
		echo.
	    call "operation.1 - Installation.DB.cmd"
		if %isError% == 1 goto :EOF

		echo.
		echo.
	    call "operation.1 - Installation.Site.cmd"
