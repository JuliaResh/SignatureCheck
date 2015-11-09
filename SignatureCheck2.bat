@echo off
@setlocal enabledelayedexpansion
@set init_path=%CD%
@echo File,Status,Status Message,Certificate Owner,Begin Date,End Date,Signing Algorithm >results.csv
@FOR /D /r %%F in ("*") DO (
    @pushd %CD% & cd %%F
    @FOR %%X in (*.exe *.dll) DO (
        @set file_path=%%F\%%X
        @set current_file=!file_path:%init_path%\=!
        @set current_folder=!current_file:\%%X=!
        @IF NOT [!current_file!]==[] (
            @echo ##teamcity[testStarted name='!current_file!']
            for /f "delims=" %%i in ('powershell $^(get-AuthenticodeSignature %%X^).Status') do set STATUS=%%i
			for /f "delims=" %%i in ('powershell $^(get-AuthenticodeSignature %%X^).StatusMessage') do set STATUS_MESSAGE=%%i
			for /f "delims=" %%i in ('powershell $^(get-AuthenticodeSignature %%X^).SignerCertificate.Subject') do set OWNER=%%i
			set OWNER=!OWNER:^"=^"^"!
			for /f "delims=" %%i in ('powershell $^(get-AuthenticodeSignature %%X^).SignerCertificate.NotBefore') do set DATE_BEGIN=%%i
			for /f "delims=" %%i in ('powershell $^(get-AuthenticodeSignature %%X^).SignerCertificate.NotAfter') do set DATE_END=%%i
			for /f "delims=" %%i in ('powershell $^(get-AuthenticodeSignature %%X^).SignerCertificate.SignatureAlgorithm.FriendlyName') do set ALGORITHM=%%i
			@echo "!current_file!","!STATUS!","!STATUS_MESSAGE!","!OWNER!","!DATE_BEGIN!","!DATE_END!","!ALGORITHM!">>!init_path!\results.csv,
        )
        @echo ##teamcity[testSuiteFinished name='!current_folder!'] 
    )
    @popd 
)