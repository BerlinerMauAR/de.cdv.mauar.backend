package de.cdv.mauar.backend.generator.exif

import org.junit.Test

import static de.cdv.mauar.backend.generator.exif.ExifDataHandler.*
import java.io.File
import org.geojson.LngLatAlt

class ExifTest {
	
	@Test
	def void testWhenExisting() {
		val inputPath = new File(System.getProperty("user.dir") + "/res/photos/F-020455.jpeg")
		val outputPath = new File(System.getProperty("user.dir") + "/res/photos/_deleteme.jpeg")
		val imgDesc = (ImageDescription.builder => [
				coord = new LngLatAlt(51.0, 12.0)
				title = "Tütel"
				photographer = "Fotogräf"
				imageDescription = "Beßchreibung"
				dateTime = "10.08.2017"
				comment = "Testkömmentar"
				license = "Unlicence"
			]).build
		setExifData(inputPath, outputPath, imgDesc)	
	}
	
	@Test
	def void testWhenNotExisting() {
		val inputPath = new File(System.getProperty("user.dir") + "/res/photos/F-020001.jpeg")
		val outputPath = new File(System.getProperty("user.dir") + "/res/photos/_deleteme.jpeg")
		val imgDesc = (ImageDescription.builder => [
				coord = new LngLatAlt(12.0, 51.0)
				title = "Tütel"
				photographer = "Fotogräf"
				imageDescription = "Beßchreibung"
				dateTime = "2017:08:12 05:00:00"
				comment = "Testkömmentar"
				tags = "MeinSchlagwort1;MeinSchlagwort2"
				license = "Unlicence"
			]).build
		setExifData(inputPath, outputPath, imgDesc)	
	}	
}