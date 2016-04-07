
@echo off

rem Parametrage - La seule partie qu'il faut modifier
rem ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
set siteSourcePath=\\lgdevam1\Partage\Publication\CAMPAGNEDAPPELS_RECETTE\app\site-web
set siteDestinationPath=C:\CAMPAGNEDAPPELS_RECETTE\Applications_Web
set siteName=campagnedappels_recette

set dbSourcePath=\\lgdevam1\Partage\Publication\CAMPAGNEDAPPELS_RECETTE\db
set dbDestinationPath=C:\CAMPAGNEDAPPELS_RECETTE\BD
set dbName=db2_simulation
set dbServer=lgdevam1
set dbUser=opera_recette
set dbPassword=legalandgeneral

set backupPath=C:\Partage\Publication\Bakup



rem Demarage de la MEP
rem ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
set currentFilePath=%~d0%~p0
cd %currentFilePath%/partie_commune
call controller.cmd
