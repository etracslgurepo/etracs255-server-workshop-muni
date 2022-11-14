@echo off

rem Setup the java command 
rem set JAVA_HOME=C:\Program Files\Java\jdk1.6.0_27

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

set JAVA_OPT="-Xmx256m -Dosiris.run.dir=%RUN_DIR% -Dosiris.base.dir=%BASE_DIR%"

"%JAVA%" "%JAVA_OPT%" -cp lib/*;. com.rameses.server.Shutdown
pause
