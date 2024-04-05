%4 -Duser.timezone=Asia/Calcutta -Duser.country=US -Duser.language=en -Duser.variant=US -jar %3 -u %1 -p %2
echo %ERRORLEVEL%
EXIT /B %ERRORLEVEL%