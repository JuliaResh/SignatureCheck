@echo off
REM this stuff should unpack everything except .exe files
@FOR /D /r %%F in ("*") DO (
    @pushd %CD%
    @cd %%F
       @FOR %%X in (*.rar *.zip *.jar *.war *.tar *.gz *.tar.gz) DO (
	        "%1\7z.exe" x -y "%%X"
	    )
    @popd
)