@ECHO OFF

SET PROD=1

IF %PROD%==1 (
REM =========================================
REM PARAMETRE DE DE LA PROD
REM =========================================
SET SITE_WEB=OPERA
SET DB_NAME=OPERA
SET DB_SERVER=LGPRODAM1
SET DB_USER=sa
SET DB_PASSWORD=neo2008!
SET SRC_PATH=\\lgdevam1\Partage\Publication\OPERA
SET SRC_WEBSITE=Applications_Web
SET SRC_USER=delivery
SET SRC_PASSWORD=delivery
SET PARTITION=f:
) ELSE (
REM =========================================
REM PARAMETRE DE DE LA RECETTE
REM =========================================
SET SITE_WEB=RECETTE_OPERA
SET DB_NAME=OPERA_RECETTE
SET DB_SERVER=LGDEVAM1
SET DB_USER=sa
SET DB_PASSWORD=legalandgeneral
SET SRC_PATH=\\lgdevam1\Partage\Publication\RECETTE_OPERA
SET SRC_WEBSITE=Applications_Internet
SET SRC_USER=delivery
SET SRC_PASSWORD=delivery
SET PARTITION=C:\OPERA_RECETTE
)

REM =========================================
REM INITIALISATION
REM =========================================
SET NEXT_MENU=0
DEL %PARTITION%\temp\temp.log

REM =========================================
REM *** Connexion a LGDEVAM1 sur R:
REM =========================================
CLS
@ECHO Deconnexion des lecteurs reseaux........................................OK
@NET USE * /d 
@NET USE R: %SRC_PATH% /USER:%SRC_USER% %SRC_PASSWORD%

IF ERRORLEVEL 53 IF NOT ERRORLEVEL 54 GOTO NET_USE_ERR_53
IF ERRORLEVEL 5  IF NOT ERRORLEVEL 6  GOTO NET_USE_ERR_5
IF ERRORLEVEL 0                       GOTO NET_USE_OK

:NET_USE_ERR_53
@ECHO Connexion sur le serveur des sources....................................KO
@ECHO      Probleme de connection sur %SRC_PATH% 
@ECHO      ou erreur de syntaxe.
@ECHO      Arrêt de la Procedure d'installation 
@pause
@ECHO OFF
GOTO EOF

:NET_USE_ERR_5
@ECHO Connexion sur le serveur des sources....................................KO
@ECHO      Probleme de droit sur %SRC_PATH% 
@ECHO      Arrêt de la Procedure d'installation 
@pause
@ECHO OFF
GOTO EOF
:NET_USE_OK

REM =========================================
REM *** Connexion a LGDEVAM1 sur R:
REM =========================================
CLS
TYPE menu.txt
:MENU
@ECHO OFF
@ECHO .
SET /P M=Taper 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, E ou Q, puis ENTREE :
IF %M%==0 GOTO GLOBAL_INSTALLATION
IF %M%==1 GOTO RESTORE
IF %M%==2 GOTO WEBSITE_BACKUP
IF %M%==3 GOTO DB_BACKUP
IF %M%==4 GOTO WEBSITE_COPY
IF %M%==5 GOTO DB_UPDATE
IF %M%==6 GOTO WEBSITE_RESTORE
IF %M%==7 GOTO DB_RESTORE
IF %M%==8 GOTO WEBSITE_STOP
IF %M%==9 GOTO WEBSITE_START
IF %M%==E GOTO WEBSITE_STATUS
IF %M%==e GOTO WEBSITE_STATUS
IF %M%==Q GOTO EOF
IF %M%==q GOTO EOF
GOTO MENU

REM =========================================
REM = INSTALLATION GLOBALE
REM =========================================
:GLOBAL_INSTALLATION
@ECHO OFF
CLS
TYPE menu.txt
SET NEXT_MENU=1
GOTO WEBSITE_STOP

REM =========================================
REM = RESTAURATION
REM =========================================
:RESTORE
CLS
TYPE menu.txt
@ECHO OFF
SET NEXT_MENU=2
GOTO WEBSITE_STOP

REM =========================================
REM = ARRET DU SITE WEB
REM =========================================
:WEBSITE_STOP
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO ON
@ECHO . 
@IIsWeb /stop %SITE_WEB%
@ECHO Arret du site web.......................................................OK
@ECHO OFF
IF "%NEXT_MENU%" == "0" GOTO MENU 
IF "%NEXT_MENU%" == "1" GOTO WEBSITE_BACKUP 
IF "%NEXT_MENU%" == "2" GOTO WEBSITE_RESTORE 

REM =========================================
REM = DEMARRAGE DU SITE WEB
REM =========================================
:WEBSITE_START
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO ON
@ECHO . 
@iisweb /start %SITE_WEB% 
@ECHO Demarrage du site web...................................................OK
@ECHO OFF

IF "%NEXT_MENU%" == "0" GOTO MENU 
IF "%NEXT_MENU%" == "1" GOTO EOF 
IF "%NEXT_MENU%" == "2" GOTO EOF 

REM =========================================
REM = ETAT DES SERVICES DU SITE WEB
REM =========================================
:WEBSITE_STATUS
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO OFF
@ECHO . 
@ECHO Satus du site web :
@iisweb /query %SITE_WEB% 

GOTO MENU

REM =========================================
REM = BACKUP DE LA BD
REM =========================================
:DB_BACKUP
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO OFF
IF EXIST %PARTITION%\temp\%DB_NAME%_MEP.BAK (
@DEL /Q /S /F %PARTITION%\temp\%DB_NAME%_MEP.BAK >> %PARTITION%\temp\temp.log
)
@sqlcmd -U %DB_USER% -P %DB_PASSWORD% -s %DB_SERVER% -i %DB_NAME%_backup.sql -o %PARTITION%\temp\%DB_NAME%_backup.log

REM ***     Gestion des erreurs
@ECHO __________________________________________________________________________
@ECHO Fichier de LOG de la sauvegarde de la base de données : 
TYPE %PARTITION%\temp\%DB_NAME%_backup.log
@ECHO __________________________________________________________________________
SET /P M=Taper 'A puis Entree' pour ARRETER,  'Entree' pour Continuer
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


REM =========================================
REM = RESTAURATION DE LA BD
REM =========================================
:DB_RESTORE
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO OFF
IF EXIST %DB_NAME%_restore.sql (
@sqlcmd -U %DB_USER% -P %DB_PASSWORD% -s %DB_SERVER% -i %DB_NAME%_restore.sql -o %PARTITION%\temp\%DB_NAME%_restore.log

REM ***     Gestion des erreurs
@ECHO __________________________________________________________________________
@ECHO Fichier de LOG de la restauration de la base de données : 
TYPE %PARTITION%\temp\%DB_NAME%_restore.log
@ECHO __________________________________________________________________________
SET /P M=Taper 'A puis Entree' pour ARRETER,  'Entree' pour Continuer
IF %M%==A GOTO DB_RESTORE_ERR_1
IF %M%==a GOTO DB_RESTORE_ERR_1

@ECHO . 
@ECHO Restauration  de la base de donnees.....................................OK
@ECHO OFF

IF "%NEXT_MENU%" == "0" GOTO MENU 
IF "%NEXT_MENU%" == "1" GOTO EOF 
IF "%NEXT_MENU%" == "2" GOTO WEBSITE_START 

:DB_RESTORE_ERR_1
@ECHO . 
@ECHO Restauration de la base de donnees......................................KO
@ECHO      Echec du script %DB_NAME%_restore.sql 
@ECHO      Arret de la restauration
@pause
@GOTO EOF

REM =========================================
REM = MISE A JOUR DE LA BD
REM =========================================
:DB_UPDATE
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO OFF
IF EXIST %PARTITION%\temp\%DB_NAME%_update.sql @DEL /Q /S %PARTITION%\temp\%DB_NAME%_update.sql >> %PARTITION%\temp\temp.log
@XCOPY R:\BDD\%DB_NAME%_update.sql %PARTITION%\temp\%DB_NAME%_update.sql /Y /S /E < %PARTITION%\MEP\f-file.txt

REM ***     Gestion des erreurs de copie
REM *** 0 - Copying was completed without error
REM *** 1 - No files found
REM *** 2 - User terminated the copy
REM *** 4 - Initialization error (not enough memory, invalid syntax, path not found)
REM *** 5 - Copy terminated due to INT 24 error reading or writing disk
IF %ERRORLEVEL% == 5 GOTO DB_NO_UPDATE_TODO
IF %ERRORLEVEL% == 4 GOTO DB_NO_UPDATE_TODO
IF %ERRORLEVEL% == 2 GOTO DB_NO_UPDATE_TODO
IF %ERRORLEVEL% == 1 GOTO DB_NO_UPDATE_TODO

@sqlcmd -U %DB_USER% -P %DB_PASSWORD% -s %DB_SERVER% -i %PARTITION%\temp\%DB_NAME%_update.sql -o %PARTITION%\temp\%DB_NAME%_update.log

REM ***     Gestion des erreurs
@ECHO __________________________________________________________________________
@ECHO Fichier de LOG de la mise à jour de la base de données : 
TYPE %PARTITION%\temp\%DB_NAME%_update.log
@ECHO __________________________________________________________________________
SET /P M=Taper 'A puis Entree' pour ARRETER,  'Entree' pour Continuer
IF %M%==A GOTO DB_RESTORE_ERR_1
IF %M%==a GOTO DB_RESTORE_ERR_1

@ECHO . 
@ECHO Mise a jour  de la base de donnees......................................OK
@ECHO OFF

IF "%NEXT_MENU%" == "0" GOTO MENU 
IF "%NEXT_MENU%" == "1" GOTO WEBSITE_COPY 
IF "%NEXT_MENU%" == "2" GOTO EOF 

:DB_NO_UPDATE_TODO
@ECHO . 
@ECHO Pas de mise a jour de la base de donnees a faire........................OK 
IF "%NEXT_MENU%" == "0" GOTO MENU 
IF "%NEXT_MENU%" == "1" GOTO WEBSITE_COPY 
IF "%NEXT_MENU%" == "2" GOTO EOF 

:DB_UPDATE_ERR_1
@ECHO . 
@ECHO Mise a jour de la base de donnees.......................................KO
@ECHO     Lancement de la Procedure de restauration 
GOTO EOF

REM =========================================
REM = SAUVEGARDE DES SOURCES APPLICATIVES
REM =========================================
:WEBSITE_BACKUP
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO OFF
IF EXIST %PARTITION%\temp\%SITE_WEB%_backup (
@DEL /Q /S /F %PARTITION%\temp\%SITE_WEB%_backup\* >> %PARTITION%\temp\temp.log
) ELSE (
@MKDIR %PARTITION%\temp\%SITE_WEB%_backup
)
@ECHO . 
@ECHO Debut de la sauvegarde des sources .....................................OK
@XCOPY %PARTITION%\%SRC_WEBSITE%\%SITE_WEB% %PARTITION%\temp\%SITE_WEB%_backup /S /E /Q /Y

REM ***     Gestion des erreurs de copie
REM *** 0 - Copying was completed without error
REM *** 1 - No files found
REM *** 2 - User terminated the copy
REM *** 4 - Initialization error (not enough memory, invalid syntax, path not found)
REM *** 5 - Copy terminated due to INT 24 error reading or writing disk
IF ERRORLEVEL 5 GOTO WEBSITE_BACKUP_ERR_5
IF ERRORLEVEL 4 GOTO WEBSITE_BACKUP_ERR_4
IF ERRORLEVEL 2 GOTO WEBSITE_BACKUP_ERR_2
IF ERRORLEVEL 1 GOTO WEBSITE_BACKUP_ERR_1
IF ERRORLEVEL 0 GOTO WEBSITE_BACKUP_OK

:WEBSITE_BACKUP_ERR_5
@ECHO . 
@ECHO Sauvegarde des sources..................................................KO
@ECHO      Memoire insuffisante pour copier les fichiers ou lecteur non valide 
@ECHO      ou erreur de syntaxe.
@ECHO      Lancement de la Procedure de restauration 
@pause
GOTO RESTORE

:WEBSITE_BACKUP_ERR_4
@ECHO Sauvegarde des sources .................................................KO
@ECHO      Erreur d'ecriture sur Disk : chemin non valide ou manque de memoire 
@ECHO      Lancement de la Procedure de restauration 
@pause
GOTO RESTORE

:WEBSITE_BACKUP_ERR_2
@ECHO . 
@ECHO Sauvegarde des sources..................................................KO
@ECHO      Vous avez appuye sur CTRL+C pour annuler la copie.
@ECHO      Lancement de la Procedure de restauration 
@pause
GOTO RESTORE

:WEBSITE_BACKUP_ERR_1
@ECHO . 
@ECHO Sauvegarde des sources..................................................KO
@ECHO      La source a copier (%PARTITION%\%SRC_WEBSITE%\%SITE_WEB%) 
@ECHO      n'a pas de contenu
@ECHO      Lancement de la Procedure de restauration 
@pause
GOTO RESTORE

:WEBSITE_BACKUP_OK
@ECHO . 
@ECHO Sauvegarde des sources..................................................OK

IF "%NEXT_MENU%" == "0" GOTO MENU 
IF "%NEXT_MENU%" == "1" GOTO DB_BACKUP 
IF "%NEXT_MENU%" == "2" GOTO EOF 

REM =========================================
REM = RESTAURATION DES SOURCES APPLICATIVES
REM =========================================
:WEBSITE_RESTORE
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO OFF
IF EXIST %PARTITION%\temp\%SITE_WEB%_backup (
@ECHO . 
@ECHO Debut de la copie des sources...........................................OK
@XCOPY %PARTITION%\temp\%SITE_WEB%_backup %PARTITION%\%SRC_WEBSITE%\%SITE_WEB%  /S /E /Q /Y

REM ***     Gestion des erreurs de copie
REM *** 0 - Copying was completed without error
REM *** 1 - No files found
REM *** 2 - User terminated the copy
REM *** 4 - Initialization error (not enough memory, invalid syntax, path not found)
REM *** 5 - Copy terminated due to INT 24 error reading or writing disk
IF ERRORLEVEL 5 GOTO WEBSITE_RESTORE_ERR_5
IF ERRORLEVEL 4 GOTO WEBSITE_RESTORE_ERR_4
IF ERRORLEVEL 2 GOTO WEBSITE_RESTORE_ERR_2
IF ERRORLEVEL 1 GOTO WEBSITE_RESTORE_ERR_1
IF ERRORLEVEL 0 GOTO WEBSITE_RESTORE_OK

:WEBSITE_RESTORE_ERR_5
@ECHO . 
@ECHO Sauvegarde des sources ................................................KO
@ECHO      Memoire insuffisante pour copier les fichiers ou lecteur non valide 
@ECHO      ou erreur de syntaxe.
@ECHO      Lancement de la Procedure de restauration 
@pause
@ECHO OFF
GOTO RESTORE

:WEBSITE_RESTORE_ERR_4
@ECHO . 
@ECHO Sauvegarde des sources..................................................KO
@ECHO      Erreur d'ecriture sur Disk : chemin non valide ou manque de memoire 
@ECHO      Lancement de la Procedure de restauration 
@pause
@ECHO OFF
GOTO RESTORE

:WEBSITE_RESTORE_ERR_2
@ECHO . 
@ECHO Sauvegarde des sources..................................................KO
@ECHO      Vous avez appuye sur CTRL+C pour annuler la copie.
@ECHO      Lancement de la Procedure de restauration 
@pause
@ECHO OFF
GOTO RESTORE

:WEBSITE_RESTORE_ERR_1
@ECHO . 
@ECHO Sauvegarde des sources..................................................KO
@ECHO      La source a copier (%PARTITION%\%SRC_WEBSITE%\%SITE_WEB%) 
@ECHO      n'a pas de contenu
@ECHO      Lancement de la Procedure de restauration 
@pause
@ECHO OFF
GOTO RESTORE

:WEBSITE_RESTORE_OK
@ECHO OFF
@ECHO . 
@ECHO Sauvegarde des sources..................................................OK
)
IF "%NEXT_MENU%" == "0" GOTO MENU 
IF "%NEXT_MENU%" == "1" GOTO EOF 
IF "%NEXT_MENU%" == "2" GOTO DB_RESTORE 

REM =========================================
REM = COPIE DES SOURCES APPLICATIVES
REM =========================================
:WEBSITE_COPY
IF "%NEXT_MENU%" == "0" CLS
IF "%NEXT_MENU%" == "0" TYPE menu.txt
@ECHO OFF
REM ------------------------------------------
REM *** Copie des sources
REM ------------------------------------------
IF EXIST %PARTITION%\%SRC_WEBSITE%\%SITE_WEB% (
@DEL /Q /S /F %PARTITION%\%SRC_WEBSITE%\%SITE_WEB%\* >> %PARTITION%\temp\temp.log
)
@ECHO . 
@ECHO Debut de la copie des sources...........................................OK
@XCOPY R:\WebSite %PARTITION%\%SRC_WEBSITE%\%SITE_WEB% /Y /S /E /Q

REM ***     Gestion des erreurs de copie
REM *** 0 - Copying was completed without error
REM *** 1 - No files found
REM *** 2 - User terminated the copy
REM *** 4 - Initialization error (not enough memory, invalid syntax, path not found)
REM *** 5 - Copy terminated due to INT 24 error reading or writing disk
IF ERRORLEVEL 5 GOTO WEBSITE_COPY_ERR_5
IF ERRORLEVEL 4 GOTO WEBSITE_COPY_ERR_4
IF ERRORLEVEL 2 GOTO WEBSITE_COPY_ERR_2
IF ERRORLEVEL 1 GOTO WEBSITE_COPY_ERR_1
IF ERRORLEVEL 0 GOTO WEBSITE_COPY_OK

:WEBSITE_COPY_ERR_5
@ECHO . 
@ECHO Copie des sources.......................................................KO
@ECHO      Memoire insuffisante pour copier les fichiers ou lecteur non valide 
@ECHO      ou erreur de syntaxe.
@ECHO      Lancement de la Procedure de restauration 
@pause
@ECHO OFF
GOTO RESTORE

:WEBSITE_COPY_ERR_4
@ECHO . 
@ECHO Copie des sources.......................................................KO
@ECHO      Erreur d'ecriture sur Disk : chemin non valide ou manque de memoire 
@ECHO      Lancement de la Procedure de restauration 
@pause
@ECHO OFF
GOTO RESTORE

:WEBSITE_COPY_ERR_2
@ECHO . 
@ECHO Copie des sources.......................................................KO
@ECHO      Vous avez appuye sur CTRL+C pour annuler la copie.
@ECHO      Lancement de la Procedure de restauration 
@pause
@ECHO OFF
GOTO RESTORE

:WEBSITE_COPY_ERR_1
@ECHO . 
@ECHO Copie des sources.......................................................KO
@ECHO      La source a copier R: n'a pas de contenu
@ECHO      Lancement de la Procedure de restauration 
@pause
@ECHO OFF
GOTO RESTORE

:WEBSITE_COPY_OK
@ECHO . 
@ECHO Copie des sources.......................................................OK
REM *** Deconnexion de R:
@ECHO OFF

IF "%NEXT_MENU%" == "0" GOTO MENU 
IF "%NEXT_MENU%" == "1" GOTO WEBSITE_START 
IF "%NEXT_MENU%" == "2" GOTO EOF 

:EOF
@NET USE R: /d
@ECHO . 
@ECHO Deconnexion sur le serveur des sources..................................OK

