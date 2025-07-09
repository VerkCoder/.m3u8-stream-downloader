@echo off
setlocal enabledelayedexpansion

:downloader
set link=%1
set output_file=%2

:: Determine path separator
set path_sep=\

:: Get script directory
for %%I in ("%~dp0.") do set "script_dir=%%~fI"

:: Build command
set "command=ffmpeg -i "%link%" -bsf:a aac_adtstoasc -vcodec copy -c copy "%script_dir%!path_sep!%output_file%""
echo !command!

set /p turn_off="Turn the computer off after downloading?.. (y/n) "
if /i "!turn_off!"=="y" (
    set turn_off_flag=true
) else (
    set turn_off_flag=false
)

set /p start_download="Start downloading?.. (y/n) "
if /i "!start_download!"=="y" (
    set time_start=%time%
    !command!
    
    :: Calculate time taken
    call :GetSeconds %time_start% start_secs
    call :GetSeconds %time% end_secs
    set /a timer=end_secs - start_secs
    
    :: Format time output
    set time_str=
    if !timer! geq 3600 (
        set /a hours=timer/3600
        set time_str=!hours!h 
        set /a timer=timer%%3600
    )
    if !timer! geq 60 (
        set /a minutes=timer/60
        set time_str=!time_str!!minutes!m 
        set /a timer=timer%%60
    )
    set time_str=!time_str!!timer!s
    
    echo Script running time: !time_str!
    
    if "!turn_off_flag!"=="true" (
        shutdown /s /t 0
    )
) else (
    echo Aborted.
)
goto :eof

:GetSeconds
set time_str=%*
set /a hours=%time_str:~0,2%
set /a minutes=%time_str:~3,2%
set /a seconds=%time_str:~6,2%
set /a total=(hours*3600)+(minutes*60)+seconds
set %4=%total%
goto :eof

:main
set /p link="Enter .m3u8 link.. "
set /p outputfile="Enter output file name.. "

:: Trim whitespace
for /f "tokens=*" %%a in ("%link%") do set "link=%%a"
for /f "tokens=*" %%a in ("%outputfile%") do set "outputfile=%%a"

if not "%outputfile%"=="" if not "%link%"=="" (
    echo %outputfile%|find ".mp4" >nul
    if !errorlevel! equ 0 (
        echo %link%|find ".m3u8" >nul
        if !errorlevel! equ 0 (
            echo %link%|find "http" >nul
            if !errorlevel! equ 0 (
                call :downloader "%link%" "%outputfile%"
            ) else (
                echo Incorrect link format(not .m3u8)
            )
        ) else (
            echo Incorrect link format(not .m3u8)
        )
    ) else (
        echo Incorrect output file format(not .mp4)
    )
) else (
    echo Parameters cannot be empty
)

endlocal