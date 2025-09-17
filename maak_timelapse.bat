:: Hoofdscript voor het maken van timelapses
@echo off
setlocal
chcp 65001 > nul
color 0A
title AXISKOM Timelapse Maker

:: Controleer of we in de juiste map zitten
if not exist "ffmpeg\bin\ffmpeg.exe" (
  echo FOUT: FFmpeg niet gevonden. Zorg ervoor dat je dit script in de originele map uitvoert.
  echo.
  pause
  exit /b
)

:: Zorg ervoor dat we werken met vertraagde variabele-expansie voor loops
setlocal EnableDelayedExpansion

:menu
cls
echo ╔══════════════════════════════════════════════════════════╗
echo ║             AXISKOM TIMELAPSE GENERATOR                ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo  Deze tool maakt een timelapse video van je foto's.
echo.
echo  [1] Maak timelapse
echo  [2] Help en uitleg
echo  [3] Afsluiten
echo.
set /p keuze=Maak je keuze (1-3): 

if "%keuze%"=="1" goto enkele_dag
if "%keuze%"=="2" goto help
if "%keuze%"=="3" exit /b
goto menu

:enkele_dag
cls
echo ╔══════════════════════════════════════════════════════════╗
echo ║                TIMELAPSE MAKER                           ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo  STAP 1: Selecteer de map met foto's
echo  ---------------------------------
echo  Je kunt een map kiezen waar je timelapse foto's staan.
echo  Deze kunnen via de webinterface gedownload zijn of van de SD-kaart.
echo.
echo  Er wordt nu een mapkeuze-venster geopend...
echo.

:: Stel eerst PATH in voor betere werking
SET PATH=%~dp0ffmpeg\bin;%PATH%

:: Gebruik VBScript voor betere compatibiliteit
echo Set objShell = CreateObject("Shell.Application") > "%temp%\folderdialog.vbs"
echo Set objFolder = objShell.BrowseForFolder(0, "Selecteer de map met timelapse foto's:", 0, 0) >> "%temp%\folderdialog.vbs"
echo If Not objFolder Is Nothing Then >> "%temp%\folderdialog.vbs"
echo     WScript.Echo objFolder.Self.Path >> "%temp%\folderdialog.vbs"
echo Else >> "%temp%\folderdialog.vbs"
echo     WScript.Echo "GEANNULEERD" >> "%temp%\folderdialog.vbs"
echo End If >> "%temp%\folderdialog.vbs"

for /f "delims=" %%I in ('cscript //nologo "%temp%\folderdialog.vbs"') do set "volledig_pad=%%I"
del "%temp%\folderdialog.vbs" > nul 2>&1

if "%volledig_pad%"=="GEANNULEERD" (
  echo Je hebt geen map geselecteerd. Probeer het opnieuw.
  pause
  goto enkele_dag
)

echo  Geselecteerde map: %volledig_pad%
echo.

:: Controleer of de geselecteerde map bestaat
if not exist "%volledig_pad%" (
  echo.
  echo FOUT: Map "%volledig_pad%" niet gevonden!
  echo.
  pause
  goto enkele_dag
)

:: SORTEER KEUZE
echo  [1] Sorteer op bestandsnaam
echo  [2] Sorteer op datum (aanbevolen)
echo.
set /p sorteer_keuze=Kies (1-2): 
if "%sorteer_keuze%"=="" set sorteer_keuze=2

:stap2_instellingen

echo.
echo  STAP 2: Kies de instellingen voor je timelapse
echo  ----------------------------------------------
echo  Geselecteerde map: %volledig_pad%
echo.
echo  Een hogere framerate (fps) maakt een snellere timelapse.
echo  Een lagere framerate maakt een langzamere timelapse.
echo.
echo  Aanbevolen waardes:
echo   - 30 fps: Korte, vloeiende timelapse
echo   - 24 fps: Filmachtige kwaliteit
echo   - 15 fps: Goede balans tussen vloeiendheid en lengte
echo   - 10 fps: Langere, maar minder vloeiende timelapse
echo.

set /p fps=Kies framerate (10-30, standaard is 30): 
if "%fps%"=="" set fps=30

echo.
echo  STAP 3: Videokwaliteit
echo  --------------------
echo  Een lager getal betekent hogere kwaliteit maar een groter bestand.
echo  Een hoger getal betekent lagere kwaliteit maar een kleiner bestand.
echo.
echo  Aanbevolen waardes:
echo   - 18: Goede balans tussen kwaliteit en bestandsgrootte (standaard)
echo   - 23: Kleinere bestanden met redelijke kwaliteit
echo   - 28: Kleinste bestanden, maar lagere kwaliteit
echo.

set /p kwaliteit=Kies kwaliteit (18-28, standaard is 18): 
if "%kwaliteit%"=="" set kwaliteit=18

cls
echo ╔══════════════════════════════════════════════════════════╗
echo ║              TIMELAPSE WORDT GEMAAKT                     ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo  Geselecteerde map: %volledig_pad%
echo  Geselecteerde framerate: %fps% fps
echo  Geselecteerde kwaliteit: %kwaliteit%
echo.

:: Uitvoerbestand maken in de huidige map
set "uitvoermap=%cd%"
for %%F in ("%volledig_pad%") do set "mapnaam=%%~nxF"

echo  De timelapse video wordt opgeslagen als: 
echo  %uitvoermap%\%mapnaam%_timelapse.mp4
echo.

:: Maak de timelapse met behulp van FFmpeg
echo  Bezig met maken van timelapse, even geduld...
echo  Dit kan enkele minuten duren, afhankelijk van het aantal foto's.
echo  SLUIT DIT VENSTER NIET AF!
echo.

:: Stel PATH tijdelijk in zodat FFmpeg beschikbaar is (nogmaals voor de zekerheid)
SET PATH=%~dp0ffmpeg\bin;%PATH%

:: Gebruik een simpelere aanpak - verwerk één bestand per keer
echo.
echo Foto's voorbereiden voor timelapse...

:: Maak een tijdelijke map voor bewerkte bestanden als die nog niet bestaat
if not exist "temp_jpgs" mkdir "temp_jpgs"

:: ORIGINELE CODE MET SORTEERKEUZE
set "teller=0"
if "%sorteer_keuze%"=="1" (
  for %%f in ("%volledig_pad%\*.jpg") do (
      set /a "teller+=1"
      echo Bestand !teller! voorbereiden: %%~nxf
      copy "%%f" "temp_jpgs\img!teller!.jpg" > nul
  )
) else (
  for /f "delims=" %%f in ('dir "%volledig_pad%\*.jpg" /b /od') do (
      set /a "teller+=1"
      echo Bestand !teller! voorbereiden: %%f
      copy "%volledig_pad%\%%f" "temp_jpgs\img!teller!.jpg" > nul
  )
)

if %teller% equ 0 (
    echo.
    echo FOUT: Geen JPG-bestanden gevonden in "%volledig_pad%"
    echo.
    pause
    rd /s /q "temp_jpgs" 2>nul
    goto menu
)

echo.
echo %teller% foto's gevonden en voorbereid.
echo Timelapse wordt gemaakt met FFmpeg...
echo.

:: Gebruik een eenvoudigere FFmpeg-opdracht met image2 demuxer
ffmpeg -y -framerate %fps% -i "temp_jpgs/img%%d.jpg" -c:v libx264 -crf %kwaliteit% -pix_fmt yuv420p "%uitvoermap%\%mapnaam%_timelapse.mp4" > nul 2>&1

:: Ruim de tijdelijke bestanden op
echo Tijdelijke bestanden opruimen...
rd /s /q "temp_jpgs" 2>nul

:: Controleer of het bestand is aangemaakt en een grootte heeft
if exist "%uitvoermap%\%mapnaam%_timelapse.mp4" (
  for %%F in ("%uitvoermap%\%mapnaam%_timelapse.mp4") do set size=%%~zF
  if !size! gtr 0 (
    echo.
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                  TIMELAPSE VOLTOOID!                     ║
    echo ╚══════════════════════════════════════════════════════════╝
    echo.
    echo  ✓ GELUKT! Je timelapse is klaar.
    echo.
    echo  De video is opgeslagen als: 
    echo  %uitvoermap%\%mapnaam%_timelapse.mp4
    echo.
    
    :: Vraag of gebruiker het bestand wil openen
    set /p open_bestand=Wil je de timelapse nu openen? (j/n): 
    if /i "%open_bestand%"=="j" (
      start "" "%uitvoermap%\%mapnaam%_timelapse.mp4"
    ) else (
      echo.
      echo Timelapse niet geopend.
      echo.
    )
    
    echo  Druk op een toets om terug te gaan naar het hoofdmenu...
    pause > nul
    goto menu
  ) else (
    goto error_handling
  )
) else (
  goto error_handling
)

:error_handling
echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║                      FOUT!                               ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo  ✗ Er is helaas iets misgegaan bij het maken van de timelapse.
echo  Controleer of er foto's (*.jpg) in de geselecteerde map staan.
echo  Map: %volledig_pad%
echo.

echo  Druk op een toets om terug te gaan naar het hoofdmenu...
pause > nul
echo Terug naar hoofdmenu...
goto menu

:help
cls
echo ╔══════════════════════════════════════════════════════════╗
echo ║                    HELP EN UITLEG                         ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo  VEELGESTELDE VRAGEN:
echo.
echo  Vraag: Hoe lang wordt mijn timelapse video?
echo  ------------------------------------------
echo  De lengte van je timelapse hangt af van het aantal foto's en de framerate:
echo   - Lengte (seconden) = Aantal foto's / Framerate
echo   - Bijvoorbeeld: 48 foto's bij 30 fps = 1,6 seconden video
echo   - Bijvoorbeeld: 48 foto's bij 10 fps = 4,8 seconden video
echo.
echo  Vraag: Waar vind ik de gemaakte timelapse?
echo  ----------------------------------------
echo  De timelapse wordt opgeslagen in dezelfde map als dit programma,
echo  met de naam van de originele fotomap plus "_timelapse.mp4".
echo  Bijvoorbeeld: "5-4_timelapse.mp4"
echo.
echo  Vraag: Wat moet ik doen als het programma niet werkt?
echo  --------------------------------------------------
echo  - Controleer of de mapnaam correct is (let op hoofdletters)
echo  - Zorg dat de map JPG-foto's bevat
echo  - Zorg dat je voldoende vrije ruimte hebt op je schijf
echo  - Zorg dat je het programma uit de originele map uitvoert
echo.
echo  Vraag: Ik krijg een Windows Defender-waarschuwing, wat nu?
echo  -------------------------------------------------------
echo  Als je een waarschuwing krijgt, klik op "Meer info" en dan op
echo  "Toch uitvoeren". Dit is normaal omdat FFmpeg niet ondertekend is.
echo.
pause
goto menu