
@echo off

rem Parametrage - La seule partie qu'il faut modifier
rem ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
set siteSourcePath=\\lgdevam1\Partage\Publication\OPERA_RECETTE_avec_sessions_actifs
set siteDestinationPath=C:\OPERA_RECETTE\Applications_Web\OPERA
set siteName=recette_opera

set dbSourcePath=\\lgdevam1\Partage\Publication\OPERA\BDD
set dbDestinationPath=C:\OPERA_RECETTE\Applications_Web\bdd
set dbName=OPERA_RECETTE
set dbServer=lgdevam1
set dbUser=opera_recette
set dbPassword=legalandgeneral

set backupPath=C:\Partage\Publication\Bakup



rem Demarage de la MEP
rem ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
set currentFilePath=%~d0%~p0
cd %currentFilePath%/partie_commune
call controller.cmd
