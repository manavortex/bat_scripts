@echo off
echo.
if [%~1]==[] ( 
	echo --- please call with target param
	goto :EOF
)
IF NOT EXIST "%~1" (
	echo --- %~1 does not exist
	goto :EOF
)
IF NOT EXIST %~1\NUL (
	echo --- %~1 is not a directory
	goto :EOF
)

IF NOT EXIST e (mkdir e)

robocopy e %~1 /mir > nul
echo --- %~1 is empty

IF EXIST e (rmdir e)
