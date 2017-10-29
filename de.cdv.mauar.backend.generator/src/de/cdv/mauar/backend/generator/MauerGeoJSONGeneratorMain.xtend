package de.cdv.mauar.backend.generator

import java.util.List
import org.geojson.Feature
import org.geojson.FeatureCollection
import org.geojson.Point

import static de.cdv.mauar.backend.generator.process.CVSParser.*
import static extension de.cdv.mauar.backend.generator.process.GeoJSONWriter.*
import de.cdv.mauar.backend.generator.process.ProcessorDefinitions

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
			]
			newFeatureCollection.add(newFeature)
		}
		newFeatureCollection
	}
}
