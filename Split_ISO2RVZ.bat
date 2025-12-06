@echo off
mkdir "%temp%\ISO2RVZ">nul
cls
echo Combinding the ISO Files...
echo Files that are being combined:
copy /b "*.part?.iso"  "%temp%\ISO2RVZ\game.iso" 
pause
cd /d C:
cd %temp%\ISO2RVZ
cls
if NOT EXIST  "DolphinTool.exe" (
	echo Downloading DolphinTool for RVZ conversion...
	curl -L -s -o dolphin.7z https://dl.dolphin-emu.org/releases/2509/dolphin-2509-x64.7z
	cls
	tar -xf "dolphin.7z"
	del /Q "dolphin.7z"
	copy "%cd%\Dolphin-x64\DolphinTool.exe" "%cd%\DolphinTool.exe"
	rmdir /S /Q "Dolphin-x64" >nul
)
cls
echo Converting ISO to RVZ...
DolphinTool.exe convert -i "game.iso" -o "game.rvz" -f rvz -b 131072 -c "zstd" -l 5
if %errorlevel% EQU 0 (
	echo Game converted successfully!
	) else (
	echo The game did not convert successfully for an unknown reason. If a lot of .ddl errors appeared, you do not have the latest Microsoft C++ Redistributable installed! Please install it by either copying this link or using google to find it.
	echo https://aka.ms/vc14/vc_redist.x64.exe
	pause
	exit
	)
cls
echo Verifying RVZ file...
DolphinTool.exe verify -i game.rvz
if %errorlevel% EQU 0 (
	echo Game verified successfully, the dump is good!
	) else (
	echo Invalid hashes! Something must have went wrong during the convertion or the dump is corrupted/imperfect.
	echo Press any key to exit.
	pause >nul
	)
echo[
echo Enter the name the rvz file should be saved at. For example "Wii Sports" will be "Wii Sports.rvz"
set /p name=File Name:
copy "game.rvz" "%userprofile%\Desktop\%name%.rvz" >nul
del /Q "%temp%\ISO2RVZ\game.rvz"
del /Q "%temp%\ISO2RVZ\game.iso"