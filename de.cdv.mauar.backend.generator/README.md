# Preparation of IDE
1. Download / Install [Xtext IDE](http://www.eclipse.org/Xtext/download.html) 
2. Import this project into workspace (as Maven project)
3. Assure you have text file encoding set to UTF-8 and text file line delimiter to unix
   (Window -> Preferences -> Workspace)
4. Java should compile to target/classes (Project -> Properties -> Java Build Path)

# Features
## Image Download
Execute `de.cdv.mauar.backend.generator.ImageDownloaderMain` to download all photos 
from [mauer-fotos.de](http://www.mauer-fotos.de/) as listed in URL column of `res/coding-da-vinci-metadaten.csv`
to local folder `res/photos`.

## Exif meta data setter
Execute `de.cdv.mauar.backend.generator.ExifDataSetterMain` to process all photos 
in local folder `res/photos` to set meta data extracted from `res/coding-da-vinci-metadaten.csv`
and store those photos to local folder `res/processed`.

### Meta data
There are several standards around plus vendor extensions introducing additional tag fields, see also
 * [Exchangeable_Image_File_Format](https://de.wikipedia.org/wiki/Exchangeable_Image_File_Format)
   * [Wikimedia Commons Exif](https://commons.wikimedia.org/wiki/Commons:Exif)
   * [Standard Exif Tags reference](http://www.exiv2.org/tags.html)
 * [Extensible Metadata Platform](https://de.wikipedia.org/wiki/Extensible_Metadata_Platform)
 * [IPTC](https://de.wikipedia.org/wiki/IPTC-IIM-Standard)
 * [metadataworkinggroup.org](http://www.metadataworkinggroup.org/)

Viewers in operating systems and hand held devices allow displaying and editing of some of those tags
 * [ExifTool by Phil Harvey](https://sno.phy.queensu.ca/~phil/exiftool/)
 * [exifdata.com](http://www.exifdata.com/)
 * [ViewExif](https://itunes.apple.com/de/app/viewexif/id945320815?mt=8)
 * [View Photo EXIF Metadata on iPhone, Mac, and Windows](https://helpdeskgeek.com/how-to/view-photo-exif-metadata-on-iphone-mac-and-windows/)

Note, that editing one field in the viewer may set the value to multiple tag fields in the image and some tags have higher priority than others (and thus hide the values of the those with lower priority).

| column in CSV | meta data standard | vendor | TIFF directory / namespace | tag name | comments |
| ------------- | ------------------ | ------ | -------------------------- | -------- | -------- |
|TITEL|EXIF|Microsoft|IFD0|XPTitle|caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|FOTOGRAF|EXIF|Microsoft|IFD0|XPAuthor|multiple authors are separated by semicolon; caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|FOTOGRAF|EXIF|Adobe|IFD0|Artist|-|
|BESCHREIBUNG_MOTIV|EXIF|Microsoft|IFD0|XPSubject|caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|DATIERUNGKONKRET|EXIF|Adobe|Exif IFD|DateTimeOriginal|expected date format: yyyy:MM:dd|
|DATIERUNGKONKRET|XMP|Adobe|http://ns.adobe.com/exif/1.0/|DateTimeOriginal|expected date format: yyyy-MM-dd'T'HH:mm:SSZ|
|DATIERUNGKONKRET|XMP|Adobe|http://ns.adobe.com/xap/1.0/|CreateDate|expected date format: yyyy-MM-dd'T'HH:mm:SSZ|
|STRASSENNAME_MOTIV|EXIF|Microsoft|IFD0|XPComment|multiple comments are separated by semicolon; caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|STRASSENNAME_MOTIV|EXIF|Adobe|Exif IFD|UserComment|multiple comments are separated by semicolon; caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|SCHLAGWORT|EXIF|Microsoft|IFD0|XPKeywords|multiple keywords are separated by semicolon; caller have to decoded it back to UTF-8; used in MS Windows Explorer (Markierung in German)|
|GEOKOORDINATEN_MOTIV|EXIF|Adobe|GPS IFD|GPSLongitude|split up in degrees, minutes, and seconds|
|GEOKOORDINATEN_MOTIV|EXIF|Adobe|GPS IFD|GPSLatitude|split up in degrees, minutes, and seconds|
|LIZENZ|EXIF|Adobe|IFD0|Copyright|caller have to decoded it back to UTF-8; also shown in MS Windows Explorer|

### Use cases
 * maintaining meta data in one place (i.e. in the image) instead of having several sources,
   so by this only one source must be transfered and queried
 * using the abilities of the viewers in operating systems, mobile devices, web to display (and
   even edit) the meta information contained in the image
 * these images can be stored in [Google Firebase Storage](https://firebase.google.com/docs/storage/) 
   so they can be downloaded quickly when needed in our mobile device app [mauAR](http://mauar.de/)

## JSON generator
Execute `de.cdv.mauar.backend.generator.PhotoLocationJSONGenerator` to process all entries from 
`res/coding-da-vinci-metadaten.csv` to have the associations between Geo coordinates and image IDs 
stored as `res/photolocations.json`. 

### Use case
This JSON file can be imported into [Google Firebase realtime database](https://firebase.google.com/docs/database/). 
This database can then be queried via Geofire API to retrieve the IDs of all images in a certain 
radius of the current Geo position of the mobile device. This ID can then be used to resolve the URL
to the actual image stored in Google Firebase Storage.

## GeoJSON generator
Run `de.cdv.mauar.backend.generator.MauerGeoJSONGeneratorMain` to generate `res/mauar_photos.geojson`
out of of `res/coding-da-vinci-metadaten.csv`

### Use case
 * You can see the Geo locations directly in [GitHub](https://github.com/BerlinerMauAR/de.cdv.mauar.backend/blob/master/de.cdv.mauar.backend.generator/res/mauar_photos.geojson)
 * You can use [geojson.io](http://geojson.io/) to display the geojson file on a map as well as see the contained
   properties in a table
 * You can use the geojson file as input for Leaflet to display it in your web application

## Map
Open local res\index.html in your browser to see geojson files displayed on a map enabled with clustering.
Additional logic will follow to allow filtering by properties (e.g. tags, year, etc.).
