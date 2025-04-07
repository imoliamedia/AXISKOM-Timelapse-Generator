# AXISKOM Timelapse Generator

Een Windows-tool voor het eenvoudig maken van timelapse video's van foto's die zijn genomen met de ESP32-CAM.

![AXISKOM Timelapse Demo](https://github.com/imoliamedia/AXISKOM-Timelapse-Tool/raw/main/demo/timelapse-demo.jpg)

## Overzicht
AXISKOM Timelapse Generator is ontwikkeld als onderdeel van het AXISKOM platform, dat zich richt op zelfredzaamheid en zelfvoorzienendheid. Deze tool automatiseert het aanmaken van timelapses van ESP32-CAM fotoreeksen en biedt een gebruiksvriendelijke interface zonder dat technische kennis van command line tools of videobewerking nodig is.

## Onderdeel van AXISKOM
Deze tool sluit aan bij de AXISKOM missie van "Zelfredzaamheid begint bij kennis" door praktische oplossingen te bieden voor:

Monitoring van moestuinen en plantgroei
Documentatie van zelfvoorzienende projecten
DIY-projecten waarbij visuele tijdsregistratie waardevol is

### Belangrijkste functies:

- Eenvoudige GUI met duidelijke stappen
- Ondersteuning voor het verwerken van foto's van één of meerdere dagen
- Aanpasbare framerate voor controle over de snelheid van de timelapse
- Kwaliteitsinstellingen om de bestandsgrootte te optimaliseren
- Werkt met foto's gemaakt via de webinterface of van de SD-kaart

## Installatie

1. Download de laatste release van de [Releases pagina](https://github.com/imoliamedia/AXISKOM-Timelapse-Tool/releases)
2. Pak het ZIP-bestand uit naar een locatie op je computer
3. Zorg dat de mapstructuur intact blijft (de `ffmpeg` map moet op hetzelfde niveau staan als `maak_timelapse.bat`)

Er is geen installatie nodig - de tool werkt direct via het batchbestand.

## Gebruik

### Voorbereiding van de foto's

Je ESP32-CAM foto's kunnen op twee manieren worden verzameld:

**Optie 1: Via de webinterface** [aanbevolen voor ESP32-CAM Timelapse Project gebruikers](https://github.com/imoliamedia/AXISKOM-ESP32-CAM-Timelapse-Project)
- Open de webinterface van je ESP32-CAM in je browser
- Navigeer naar de foto's en download de gewenste dag(en)
- Sla deze op in een map op je computer

**Optie 2: Via de SD-kaart**
- Haal de SD-kaart uit je ESP32-CAM
- Plaats de SD-kaart in je computer
- Kopieer de mappen met foto's naar een locatie op je computer

### Het maken van een timelapse

1. Dubbelklik op `maak_timelapse.bat`
2. Kies "Maak timelapse van één dag" in het menu
3. Selecteer de map met de foto's wanneer het dialoogvenster verschijnt
4. Stel de framerate in (fps):
   - 30 fps: Vloeiende, maar korte timelapse
   - 24 fps: Filmachtige kwaliteit
   - 15 fps: Goede balans tussen vloeiendheid en lengte
   - 10 fps: Langere timelapse, maar minder vloeiend
5. Kies de videokwaliteit (18-28):
   - Lagere waarden geven hogere kwaliteit maar grotere bestanden
6. Wacht tot de timelapse is gegenereerd
7. Na voltooiing kun je kiezen om de timelapse direct te bekijken

De timelapse wordt opgeslagen in dezelfde map als het hulpprogramma, met de naam van de geselecteerde map plus "_timelapse.mp4".

## Vereisten

- Windows 10 of hoger
- Ongeveer 100MB vrije ruimte (voor de tool)
- Voldoende ruimte voor de timelapse video's (afhankelijk van kwaliteitsinstellingen)

## Veelgestelde vragen

### Hoe lang wordt mijn timelapse video?
De lengte hangt af van het aantal foto's en de gekozen framerate:
- Lengte (seconden) = Aantal foto's ÷ Framerate
- Bijvoorbeeld: 48 foto's bij 30 fps = 1,6 seconden timelapse

### Wat als ik een Windows Defender-waarschuwing krijg?
De tool gebruikt FFmpeg, een open-source tool voor videobewerking. Omdat deze niet digitaal ondertekend is, kan Windows Defender een waarschuwing geven. Je kunt veilig op "Meer info" en vervolgens "Toch uitvoeren" klikken.

### Kan ik timelapses maken van meerdere dagen?
Ja, hiervoor kun je:
1. Een nieuwe map maken
2. Alle foto's van verschillende dagen naar deze map kopiëren
3. Het programma gebruiken om een timelapse te maken van deze gecombineerde map

## Technische details

De tool maakt gebruik van:
- FFmpeg voor videoconversie en encodering
- Windows batch scripting voor gebruikersinterface en bestandsverwerking
- H.264 videocodec voor optimale compatibiliteit

## Licentie

Dit project is gelicenseerd onder de [MIT License](LICENSE).

## Credits

- Ontwikkeld voor het AXISKOM Timelapse Project
- Gebruikt [FFmpeg](https://ffmpeg.org/) voor videoconversie

---

## Contact

Bij vragen of problemen, open een issue op deze GitHub repository.