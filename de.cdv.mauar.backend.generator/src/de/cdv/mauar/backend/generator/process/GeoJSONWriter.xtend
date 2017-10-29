package de.cdv.mauar.backend.generator.process

import com.fasterxml.jackson.databind.ObjectMapper
import java.io.BufferedWriter
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStreamWriter
import org.geojson.FeatureCollection

interface GeoJSONWriter {

	def static void writeFile(FeatureCollection newFeatureCollection, String fileName) {
		val json = new ObjectMapper().writeValueAsString(newFeatureCollection);
		val out = new File(fileName)
		val fos = new FileOutputStream(out)
		val osw = new OutputStreamWriter(fos, "UTF-8")
		val fw = new BufferedWriter(osw)
		fw.write(json)
		fw.flush
		fw.close
		osw.close
		fos.close
	}	
}