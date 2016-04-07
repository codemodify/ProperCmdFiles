
:showMenu()
        echo.
        echo.
        echo =============================================================================
        echo =========  Mise en Production  ==============================================
        echo.
        echo 1 - Installation / Mis a Jour
        echo 2 - Restauration
        echo 3 - Backup
        echo.
        echo Q - Quitter
        echo.     
        echo =============================================================================
        echo.

:readInput()
        set /P M=Taper 1, 2, 3 ou Q, puis ENTREE : 

        if %M%==1 call "operation.1 - Installation.cmd"
        if %M%==2 call "operation.2 - Restauration.cmd"
        if %M%==3 call "operation.3 - Backup.cmd"

        if %M%==Q goto :EOF
        if %M%==q goto :EOF
        
        goto showMenu()
