@echo off

REM cls

echo Initialize MSSQL database for your C#.NET website ...

REM Get command line parameters.
set db=%1

REM if "" == %db% goto LErrBat
if "%db%" == "" goto LErrBat

REM Hard code this for now.
set db="CI35" 

echo.
echo Create database ...
sqlcmd -E -b -S localhost -i makedb.sql -v dbname=%db%
IF ERRORLEVEL 1 goto LErrSql

echo.
echo Load data into database ...
sqlcmd -E -b -S localhost -i load_data.sql -v dbname=%db%
IF ERRORLEVEL 1 goto LErrSql

goto LExit

:LErrBat
echo Usage: init.bat [dbname]
REM echo.
goto LExit

:LErrSql
echo Sql execution error. 
goto LExit

:LExit
echo.
REM pause 

