package de.cdv.mauar.backend.generator

import de.cdv.mauar.backend.generator.process.ProcessorDefinitions
import java.time.ZoneId
import java.time.ZonedDateTime
import java.util.Arrays
import java.util.List
import org.geojson.Feature
import org.geojson.FeatureCollection
import org.geojson.Point

import static de.cdv.mauar.backend.generator.process.CVSParser.*

import static extension de.cdv.mauar.backend.generator.process.GeoJSONWriter.*

class MauerGeoJSONGeneratorMain implements ProcessorDefinitions {

	def static void main(String[] args) {
		val input = System.getProperty("user.dir") + "/res/coding-da-vinci-metadaten.csv"
		val keysAndValues = getKeysAndValues(input)
		val featureCollection = fillFeatureCollection(keysAndValues)
		featureCollection.writeFile("res/mauar_photos.geojson")
	}
	
	protected def static FeatureCollection fillFeatureCollection(Pair<List<String>, List<List<String>>> keysAndValues) {
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		val newFeatureCollection = new FeatureCollection
		for (values : valuesList) {
			val newFeature = new Feature => [
				id = String.valueOf(ID_PROCESSOR.apply(values, keys))
				PROP_PROCESSORS.forEach(proc|proc.apply(properties, values, keys))
				geometry = POINT_PROCESSOR.apply(values, keys) as Point
				val datierungVon = datierungVonProc.apply(values, keys)
				it.properties.put("coordTimes", Arrays.asList(toMilliseconds(datierungVon)))
			]
			if((newFeature.geometry as Point).coordinates !== null && newFeature.properties.containsKey("datierungVon")) {
				newFeatureCollection.add(newFeature)
			}
		}
		newFeatureCollection
	}
	
	protected def static long toMilliseconds(Object datierungVon) {
		if(datierungVon === null) return 0
		try {
			val year = Integer.valueOf(String.valueOf(datierungVon))
			ZonedDateTime.of(year, 1, 1, 0, 0, 0, 0, ZoneId.of("UTC")).toInstant.toEpochMilli
		} catch(NumberFormatException nfe) {
			0		
		}
	}
}
