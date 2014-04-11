@echo off
@setlocal enabledelayedexpansion
@set init_path=%CD%
@FOR /D /r %%F in ("*") DO (
    @pushd %CD% & cd %%F
    @FOR %%X in (*.exe *.dll) DO (
        @set file_path=%%F\%%X
        @set current_file=!file_path:%init_path%\=!
        @set current_folder=!current_file:\%%X=!
        @echo ##teamcity[testSuiteStarted name='!current_folder!']
        @IF NOT [!current_file!]==[] (
            @echo ##teamcity[testStarted name='!current_file!']
            @FOR /f "delims=" %%i in ('"%1\signtool.exe" verify /pa %%X 2^>^&1') do set output=%%i
	        @IF NOT "!output!"=="!output:Successfully verified=!" (
                    @echo ##teamcity[name='!current_file!' message='!output!']
	        ) else (
                    @echo ##teamcity[testFailed name='!current_file!' message='!output!']
                )
            @echo ##teamcity[testFinished name='!current_file!']
        )
        @echo ##teamcity[testSuiteFinished name='!current_folder!'] 
    )
    @popd 
)