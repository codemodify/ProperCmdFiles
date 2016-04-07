REM =========================================
REM = BACKUP DE LA BD
REM =========================================
:DB_BACKUP
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO OFF
IF EXIST %LOCAL_TEMP_FOLDER%\%DB_NAME%_MEP.BAK (
@DEL /Q /S /F %LOCAL_TEMP_FOLDER%\%DB_NAME%_MEP.BAK >> %LOCAL_TEMP_FOLDER%\temp.log
)
@sqlcmd -U %DB_USER% -P %DB_PASSWORD% -s %DB_SERVER% -i %DB_NAME%_backup.sql -o %LOCAL_TEMP_FOLDER%\%DB_NAME%_backup.log

REM ***     Gestion des erreurs
@ECHO __________________________________________________________________________
@ECHO Fichier de LOG de la sauvegarde de la base de données : 
TYPE %LOCAL_TEMP_FOLDER%\%DB_NAME%_backup.log
@ECHO __________________________________________________________________________
set /P M=Taper 'A puis Entree' pour ARRETER,  'Entree' pour Continuer
IF %M%==A GOTO DB_BACKUP_ERR_1
IF %M%==a GOTO DB_BACKUP_ERR_1

@ECHO . 
@ECHO Sauvegarde de la base de donnees........................................OK

IF "%NEXT_MENU%" == "0" GOTO MENU 
IF "%NEXT_MENU%" == "1" GOTO DB_UPDATE 
IF "%NEXT_MENU%" == "2" GOTO EOF 

:DB_BACKUP_ERR_1
@ECHO . 
@ECHO Sauvegarde de la base de donnees........................................KO
@ECHO      Echec du script %DB_NAME%_backup.sql 
@ECHO      Arret de l'installation
@pause
@GOTO EOF