@echo off
 
TITLE MeuProcessoAutomatico
SET currentdir=%~dp0
SET kitchen=C:\Pentaho\data-integration\Kitchen.bat
SET logfile="%currentdir%log.txt"
 
echo. >> %logfile%
echo. >> %logfile%

"%kitchen%" /file:"%currentdir%Covid19_job.kjb" /level:Basic >> %logfile%