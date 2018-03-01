@REM ----------------------------------------------------------------------------
@REM  Copyright 2001-2006 The Apache Software Foundation.
@REM
@REM  Licensed under the Apache License, Version 2.0 (the "License");
@REM  you may not use this file except in compliance with the License.
@REM  You may obtain a copy of the License at
@REM
@REM       http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM  Unless required by applicable law or agreed to in writing, software
@REM  distributed under the License is distributed on an "AS IS" BASIS,
@REM  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM  See the License for the specific language governing permissions and
@REM  limitations under the License.
@REM ----------------------------------------------------------------------------
@REM
@REM   Copyright (c) 2001-2006 The Apache Software Foundation.  All rights
@REM   reserved.

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup
set REPO=


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\repo

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\cproject-0.7.0-SNAPSHOT.jar;"%REPO%"\guava-18.0.jar;"%REPO%"\svg2xml-2.4.0-SNAPSHOT.jar;"%REPO%"\pdf2svg-2.4.0-SNAPSHOT.jar;"%REPO%"\pdfbox-1.8.8.jar;"%REPO%"\fontbox-1.8.8.jar;"%REPO%"\jempbox-1.8.8.jar;"%REPO%"\commons-logging-1.1.1.jar;"%REPO%"\svghtml-1.0.0-SNAPSHOT.jar;"%REPO%"\euclid-2.2.1-SNAPSHOT.jar;"%REPO%"\junit-4.8.2.jar;"%REPO%"\log4j-1.2.16.jar;"%REPO%"\commons-lang3-3.0.jar;"%REPO%"\commons-math-2.2.jar;"%REPO%"\joda-time-1.6.2.jar;"%REPO%"\xom-1.2.5.jar;"%REPO%"\jtidy-4aug2000r7-dev.jar;"%REPO%"\tagsoup-1.2.jar;"%REPO%"\htmlunit-2.15.jar;"%REPO%"\xalan-2.7.1.jar;"%REPO%"\serializer-2.7.1.jar;"%REPO%"\commons-collections-3.2.1.jar;"%REPO%"\httpclient-4.3.3.jar;"%REPO%"\httpcore-4.3.2.jar;"%REPO%"\httpmime-4.3.3.jar;"%REPO%"\commons-codec-1.9.jar;"%REPO%"\htmlunit-core-js-2.15.jar;"%REPO%"\xercesImpl-2.11.0.jar;"%REPO%"\nekohtml-1.9.21.jar;"%REPO%"\cssparser-0.9.14.jar;"%REPO%"\sac-1.3.jar;"%REPO%"\jetty-websocket-8.1.15.v20140411.jar;"%REPO%"\jetty-util-8.1.15.v20140411.jar;"%REPO%"\jetty-io-8.1.15.v20140411.jar;"%REPO%"\jetty-http-8.1.15.v20140411.jar;"%REPO%"\bcprov-jdk16-1.46.jar;"%REPO%"\gson-2.8.2.jar;"%REPO%"\commons-csv-1.2.jar;"%REPO%"\imageanalysis-1.3.0-SNAPSHOT.jar;"%REPO%"\io-0.17.jar;"%REPO%"\ddogleg-0.5.jar;"%REPO%"\ip-0.17.jar;"%REPO%"\xstream-1.4.7.jar;"%REPO%"\xmlpull-1.1.3.1.jar;"%REPO%"\xpp3_min-1.1.4c.jar;"%REPO%"\georegression-0.6.jar;"%REPO%"\ejml-0.25.jar;"%REPO%"\feature-0.17.jar;"%REPO%"\visualize-0.17.jar;"%REPO%"\recognition-0.17.jar;"%REPO%"\sfm-0.17.jar;"%REPO%"\calibration-0.17.jar;"%REPO%"\geo-0.17.jar;"%REPO%"\imgscalr-lib-4.2.jar;"%REPO%"\Saxon-HE-9.6.0-3.jar;"%REPO%"\opennlp-tools-1.6.0.jar;"%REPO%"\json-path-2.0.0.jar;"%REPO%"\slf4j-api-1.7.10.jar;"%REPO%"\json-smart-2.1.1.jar;"%REPO%"\asm-1.0.2.jar;"%REPO%"\asm-3.3.1.jar;"%REPO%"\jsoup-1.8.2.jar;"%REPO%"\xmlunit-1.4.jar;"%REPO%"\commons-io-2.4.jar;"%REPO%"\xml-apis-1.4.01.jar;"%REPO%"\norma-0.7.0-alpha.jar

set ENDORSED_DIR=
if NOT "%ENDORSED_DIR%" == "" set CLASSPATH="%BASEDIR%"\%ENDORSED_DIR%\*;%CLASSPATH%

if NOT "%CLASSPATH_PREFIX%" == "" set CLASSPATH=%CLASSPATH_PREFIX%;%CLASSPATH%

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS%  -classpath %CLASSPATH% -Dapp.name="norma" -Dapp.repo="%REPO%" -Dapp.home="%BASEDIR%" -Dbasedir="%BASEDIR%" org.xmlcml.norma.Norma %CMD_LINE_ARGS%
if %ERRORLEVEL% NEQ 0 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=%ERRORLEVEL%

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@REM If error code is set to 1 then the endlocal was done already in :error.
if %ERROR_CODE% EQU 0 @endlocal


:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
