@echo off
if exist env.conf (
	for /f "delims=" %%x in (env.conf) do (
		set str=%%x
		if not "!str:~0,1!" == "#" set "%%x" 
	) 
) 

rem Setup the java command
rem set JAVA_HOME=C:\Apps\jdk7u80-x64

if not "%JAVA7_HOME%" == "" set JAVA_HOME=%JAVA7_HOME%
if not "%JAVA8_HOME%" == "" set JAVA_HOME=%JAVA8_HOME%

set JAVA=java
if not "%JAVA_HOME%" == "" set JAVA=%JAVA_HOME%\bin\java

rem This will be the run directory
set RUN_DIR=%cd%

rem Move up...
cd ..

rem This will be the base directory
set BASE_DIR=%cd%

set JAVA_OPT_XMX=2048
if not "%JAVA_XMX%" == "" set JAVA_OPT_XMX=%JAVA_XMX%

set JAVA_OPT="-Xms512m -Xmx%JAVA_OPT_XMX%m -Dosiris.run.dir=%RUN_DIR% -Dosiris.base.dir=%BASE_DIR%"

echo .=================================================================
echo .
echo . Osiris3 Server (ETRACS)
echo .
echo . JAVA      : %JAVA% 
echo . JAVA_HOME : %JAVA_HOME% 
echo . JAVA_OPTS : %JAVA_OPT% 
echo .
echo .=================================================================
echo .


"%JAVA%" "%JAVA_OPT%" -cp lib/*;. com.rameses.main.bootloader.MainBootLoader
pause
