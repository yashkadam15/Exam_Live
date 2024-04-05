%5 -Duser.timezone=Asia/Calcutta -Duser.country=US -Duser.language=en -Duser.variant=US -jar %4 -u %1 -p %2 -e %3
echo %ERRORLEVEL%
EXIT /B %ERRORLEVEL%