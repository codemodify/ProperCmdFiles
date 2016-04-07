
setlocal EnableDelayedExpansion

    set i=1

    :start
        call :DisplayProgressBar %i%

    :replace the next line by the operation you want to do
        ping -n 1 127.0.0.1 > NUL
        set /a i = i + 1
        if /i %i% leq 10 goto start

        goto :EOF

    :DisplayProgressBar
        (Set /P j=.) < NUL
        exit /b

endlocal
