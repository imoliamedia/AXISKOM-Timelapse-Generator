# AXISKOM Timelapse Generator

Een Windows-tool voor het eenvoudig maken van timelapse video's van foto's die zijn genomen met de ESP32-CAM.

![AXISKOM Timelapse Demo](https://github.com/imoliamedia/AXISKOM-Timelapse-Generator/blob/main/screenshots/4.kwaliteit_keuze.png)

Meer [Screenshots](https://github.com/imoliamedia/AXISKOM-Timelapse-Generator/tree/main/screenshots)

## Overzicht
AXISKOM Timelapse Generator is ontwikkeld als onderdeel van het AXISKOM platform, dat zich richt op zelfredzaamheid en zelfvoorzienendheid. Deze tool automatiseert het aanmaken van timelapses van ESP32-CAM fotoreeksen en biedt een gebruiksvriendelijke interface zonder dat technische kennis van command line tools of videobewerking nodig is.

## Onderdeel van AXISKOM
Deze tool sluit aan bij de AXISKOM missie van "Zelfredzaamheid begint bij kennis" door praktische oplossingen te bieden voor:

- Monitoring van moestuinen en plantgroei
- Documentatie van zelfvoorzienende projecten
- DIY-projecten waarbij visuele tijdsregistratie waardevol is

### Belangrijkste functies:

- **Eenvoudige GUI** met duidelijke stappen
- **Slimme sorteeropties** - kies tussen bestandsnaam of datum/tijd sortering
- **Aanpasbare framerate** voor controle over de snelheid van de timelapse
- **Kwaliteitsinstellingen** om de bestandsgrootte te optimaliseren
- **Werkt perfect** met foto's gemaakt via de webinterface of van de SD-kaart
- **Chronologisch correcte timelapses** door datum-sortering

## Nieuwe Features (v2.0)

### ⭐ Intelligente Foto-Sortering
De tool biedt nu twee sorteeropties om ervoor te zorgen dat je timelapse chronologisch correct is:

**Optie 1: Sorteren op bestandsnaam**
- Voor foto's die al correct genummerd zijn (foto001.jpg, foto002.jpg, etc.)
- Alfabetische/numerieke sortering

**Optie 2: Sorteren op datum en tijd** ⭐ **AANBEVOLEN**
- Automatisch sorteren op wanneer de foto gemaakt/opgeslagen is
- **Perfect voor ESP32-CAM foto's** die over langere periodes zijn gemaakt
- Voorkomt problemen met foto's die niet op volgorde staan
- Zorgt altijd voor chronologisch correcte timelapses

## Installatie

1. Download de laatste release van de [Releases pagina](https://github.com/imoliamedia/AXISKOM-Timelapse-Generator/releases/tag/Release)
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
2. Kies "Maak timelapse" in het menu
3. Selecteer de map met de foto's wanneer het dialoogvenster verschijnt
4. **NIEUW**: Kies je sorteervoorkeur:
   - **[1] Bestandsnaam**: Voor reeds correct genummerde foto's
   - **[2] Datum en tijd**: ⭐ Aanbevolen voor ESP32-CAM foto's
5. Stel de framerate in (fps):
   - 30 fps: Vloeiende, maar korte timelapse
   - 24 fps: Filmachtige kwaliteit
   - 15 fps: Goede balans tussen vloeiendheid en lengte
   - 10 fps: Langere timelapse, maar minder vloeiend
6. Kies de videokwaliteit (18-28):
   - Lagere waarden geven hogere kwaliteit maar grotere bestanden
7. Wacht tot de timelapse is gegenereerd
8. Na voltooiing kun je kiezen om de timelapse direct te bekijken

De timelapse wordt opgeslagen in dezelfde map als het hulpprogramma, met de naam van de geselecteerde map plus "_timelapse.mp4".

## Waarom Datum-Sortering Gebruiken?

### Het Probleem
ESP32-CAM's maken foto's over lange periodes (dagen, weken, maanden). Wanneer je deze foto's kopieert of downloadt, kunnen ze in de verkeerde volgorde terechtkomen. Dit resulteert in timelapses die:
- Heen en weer springen in tijd
- Niet chronologisch correct zijn
- Verwarrend of onbruikbaar zijn

### De Oplossing
Door **datum en tijd sortering** te kiezen:
- ✅ Foto's worden automatisch op chronologische volgorde gezet
- ✅ Tijdreizen in je timelapse worden voorkomen
- ✅ Perfect geschikt voor lange-termijn timelapses
- ✅ Werkt met foto's van de SD-kaart én webinterface downloads

### Voorbeeld
**Voor datum-sortering:**
- foto_1_5.jpg (gemaakt om 14:00)
- foto_1_6.jpg (gemaakt om 08:00) 
- foto_1_7.jpg (gemaakt om 12:00)

**Na datum-sortering:**
- foto_1_6.jpg (08:00) → frame 1
- foto_1_7.jpg (12:00) → frame 2  
- foto_1_5.jpg (14:00) → frame 3

## Vereisten

- Windows 10 of hoger
- Ongeveer 100MB vrije ruimte (voor de tool)
- Voldoende ruimte voor de timelapse video's (afhankelijk van kwaliteitsinstellingen)

## Veelgestelde vragen

### Wanneer gebruik ik welke sorteeroptie?
**Datum en tijd (aanbevolen):**
- Voor alle ESP32-CAM foto's
- Bij foto's gemaakt over langere periodes
- Wanneer je zeker wilt zijn van chronologische volgorde
- Bij downloads van de webinterface

**Bestandsnaam:**
- Alleen wanneer foto's al perfect genummerd zijn
- Voor handmatig gehernoembde foto's
- Bij foto's die al op volgorde staan

### Hoe lang wordt mijn timelapse video?
De lengte hangt af van het aantal foto's en de gekozen framerate:
- Lengte (seconden) = Aantal foto's ÷ Framerate
- Bijvoorbeeld: 48 foto's bij 30 fps = 1,6 seconden timelapse
- Bijvoorbeeld: 1440 foto's bij 30 fps = 48 seconden timelapse

### Wat als ik een Windows Defender-waarschuwing krijg?
De tool gebruikt FFmpeg, een open-source tool voor videobewerking. Omdat deze niet digitaal ondertekend is, kan Windows Defender een waarschuwing geven. Je kunt veilig op "Meer info" en vervolgens "Toch uitvoeren" klikken.

### Kan ik timelapses maken van meerdere dagen?
Ja! Dit is waar de datum-sortering echt uitblinkt:
1. Maak een nieuwe map
2. Kopieer alle foto's van verschillende dagen naar deze map
3. Kies **datum en tijd sortering**
4. De tool zet alle foto's automatisch op chronologische volgorde

### Mijn timelapse springt heen en weer in tijd, wat nu?
Dit probleem wordt opgelost door **datum en tijd sortering** te gebruiken in plaats van bestandsnaam sortering.

## Technische details

De tool maakt gebruik van:
- FFmpeg voor videoconversie en encodering
- Windows batch scripting voor gebruikersinterface en bestandsverwerking
- H.264 videocodec voor optimale compatibiliteit
- Datum-gebaseerde sortering via Windows DIR commando's

## Changelog

### v2.0 (Nieuw)
- ✅ **Toegevoegd**: Keuze tussen bestandsnaam en datum/tijd sortering
- ✅ **Verbeterd**: Chronologisch correcte timelapses voor ESP32-CAM foto's  
- ✅ **Opgelost**: Probleem met verkeerde foto-volgorde bij lange timelapses
- ✅ **Standaard**: Datum-sortering als aanbevolen optie

### v1.0 (Origineel)
- Basis timelapse functionaliteit
- Framerate en kwaliteit instellingen
- FFmpeg integratie

## Licentie

Dit project is gelicenseerd onder de [GPL-3.0 license](LICENSE).

## Credits

- Ontwikkeld voor het AXISKOM Timelapse Project
- Gebruikt [FFmpeg](https://ffmpeg.org/) voor videoconversie

---

## Contact

Bij vragen of problemen, open een issue op deze GitHub repository.

**Voor specifieke ESP32-CAM vragen**: Bekijk het [AXISKOM ESP32-CAM Timelapse Project](https://github.com/imoliamedia/AXISKOM-ESP32-CAM-Timelapse-Project)