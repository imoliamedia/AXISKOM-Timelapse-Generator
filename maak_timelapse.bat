:: Hoofdscript voor het maken van timelapses
@echo off
setlocal EnableDelayedExpansion
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

:: PATH wordt hier eenmalig ingesteld voor de hele sessie (niet steeds opnieuw
:: bij elke timelapse, dat liet PATH bij herhaald gebruik onnodig aangroeien)
SET "PATH=%~dp0ffmpeg\bin;%PATH%"

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
:sorteer_keuze_vraag
set /p sorteer_keuze=Kies (1-2):
if "%sorteer_keuze%"=="" set "sorteer_keuze=2"
if not "%sorteer_keuze%"=="1" if not "%sorteer_keuze%"=="2" (
  echo  Ongeldige keuze, kies 1 of 2.
  goto sorteer_keuze_vraag
)

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

:fps_vraag
set /p fps=Kies framerate (10-30, standaard is 30):
if "%fps%"=="" set "fps=30"
set "fps_ongeldig="
for /f "delims=0123456789" %%c in ("%fps%") do set "fps_ongeldig=1"
if defined fps_ongeldig (
  echo  Ongeldige invoer: gebruik een heel getal.
  goto fps_vraag
)
if %fps% lss 1 (
  echo  Framerate moet minimaal 1 zijn.
  goto fps_vraag
)

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

:kwaliteit_vraag
set /p kwaliteit=Kies kwaliteit (18-28, standaard is 18):
if "%kwaliteit%"=="" set "kwaliteit=18"
set "kwaliteit_ongeldig="
for /f "delims=0123456789" %%c in ("%kwaliteit%") do set "kwaliteit_ongeldig=1"
if defined kwaliteit_ongeldig (
  echo  Ongeldige invoer: gebruik een heel getal tussen 0 en 51.
  goto kwaliteit_vraag
)
if %kwaliteit% gtr 51 (
  echo  Kwaliteit moet tussen 0 en 51 liggen.
  goto kwaliteit_vraag
)

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

:: Foto's worden NIET meer gekopieerd naar een tijdelijke map: in plaats
:: daarvan bouwen we een FFmpeg concat-lijst die in de juiste volgorde
:: rechtstreeks naar de originele bestanden verwijst. Dat is sneller,
:: gebruikt geen dubbele schijfruimte en laat niks achter voor de volgende
:: run (een oude, halfvolle tijdelijke map kon anders stiekem oude foto's
:: aan het eind van een nieuwe timelapse plakken).
echo.
echo Foto's sorteren...

set "lijstbestand=%temp%\axiskom_concat_%random%.txt"
if exist "%lijstbestand%" del "%lijstbestand%"
set "veiligpad=%volledig_pad:\=/%"

:: Duur per foto in seconden, met microseconde-precisie (bv. 30 fps -> 0.033333)
set /a "duur_micro=1000000/%fps%"
set "duur_pad=00000%duur_micro%"
set "duur=0.%duur_pad:~-6%"

set "teller=0"
set "laatste_bestand="

if "%sorteer_keuze%"=="1" (
  for /f "delims=" %%f in ('dir /b /on "%volledig_pad%\*.jpg" 2^>nul') do (
      set /a "teller+=1"
      set "laatste_bestand=%%f"
      echo file '!veiligpad!/%%f'>>"!lijstbestand!"
      echo duration !duur!>>"!lijstbestand!"
      set /a "voortgang=!teller! %% 100"
      if !voortgang! equ 0 echo   ...!teller! foto's verwerkt
  )
) else (
  :: Sorteer op de datum/tijd die in de ESP32-CAM bestandsnaam zelf staat
  :: (DD-MM-YYYY_HH-MM-SS.jpg), in plaats van op de Windows-bestandsdatum.
  :: Die laatste klopt namelijk niet meer als de foto's via de webinterface
  :: gedownload zijn: dan is de bestandsdatum het downloadmoment, niet het
  :: opnamemoment, en sorteert "dir /od" dus verkeerd.
  set "sorteerbestand=%temp%\axiskom_sort_%random%.txt"
  if exist "%sorteerbestand%" del "%sorteerbestand%"
  for %%f in ("%volledig_pad%\*.jpg") do (
      set "basisnaam=%%~nf"
      set "sleutel=!basisnaam!"
      if "!basisnaam:~2,1!"=="-" if "!basisnaam:~5,1!"=="-" if "!basisnaam:~10,1!"=="_" if "!basisnaam:~13,1!"=="-" if "!basisnaam:~16,1!"=="-" (
          set "dd=!basisnaam:~0,2!"
          set "mm=!basisnaam:~3,2!"
          set "jjjj=!basisnaam:~6,4!"
          set "hh=!basisnaam:~11,2!"
          set "mi=!basisnaam:~14,2!"
          set "ss=!basisnaam:~17,2!"
          set "sleutel=!jjjj!!mm!!dd!!hh!!mi!!ss!"
      )
      echo !sleutel!^|%%~nxf>>"!sorteerbestand!"
  )
  if exist "%sorteerbestand%" (
      sort "%sorteerbestand%" > "%sorteerbestand%.sorted"
      for /f "usebackq tokens=1,2 delims=|" %%A in ("%sorteerbestand%.sorted") do (
          set /a "teller+=1"
          set "laatste_bestand=%%B"
          echo file '!veiligpad!/%%B'>>"!lijstbestand!"
          echo duration !duur!>>"!lijstbestand!"
          set /a "voortgang=!teller! %% 100"
          if !voortgang! equ 0 echo   ...!teller! foto's verwerkt
      )
  )
  del "%sorteerbestand%" "%sorteerbestand%.sorted" 2>nul
)

if %teller% equ 0 (
    echo.
    echo FOUT: Geen JPG-bestanden gevonden in "%volledig_pad%"
    echo.
    pause
    del "%lijstbestand%" 2>nul
    goto menu
)

:: FFmpeg's concat-demuxer negeert de duration van de allerlaatste regel;
:: de laatste foto daarom nog eenmaal toevoegen (bekende, gangbare workaround)
if defined laatste_bestand echo file '%veiligpad%/%laatste_bestand%'>>"%lijstbestand%"

echo.
echo %teller% foto's gevonden.
echo Timelapse wordt gemaakt met FFmpeg...
echo.

set "ffmpeglog=%temp%\axiskom_ffmpeg_log.txt"
ffmpeg -y -f concat -safe 0 -i "%lijstbestand%" -vsync cfr -r %fps% -c:v libx264 -crf %kwaliteit% -pix_fmt yuv420p "%uitvoermap%\%mapnaam%_timelapse.mp4" > "%ffmpeglog%" 2>&1

:: Ruim de tijdelijke lijst op
del "%lijstbestand%" 2>nul

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
if exist "%ffmpeglog%" (
  echo  Technische details ^(FFmpeg-foutmelding^) zijn opgeslagen in:
  echo  %ffmpeglog%
  echo.
)

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
echo  - Bekijk bij een foutmelding het genoemde logbestand voor de exacte
echo    FFmpeg-foutmelding
echo.
echo  Vraag: Ik krijg een Windows Defender-waarschuwing, wat nu?
echo  -------------------------------------------------------
echo  Als je een waarschuwing krijgt, klik op "Meer info" en dan op
echo  "Toch uitvoeren". Dit is normaal omdat FFmpeg niet ondertekend is.
echo.
pause
goto menu