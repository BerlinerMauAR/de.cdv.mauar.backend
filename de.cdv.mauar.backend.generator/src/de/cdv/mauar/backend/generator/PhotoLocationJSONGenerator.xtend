package de.cdv.mauar.backend.generator

import de.cdv.mauar.backend.generator.process.ProcessorDefinitions
import org.geojson.Point

import static de.cdv.mauar.backend.generator.process.CVSParser.*

import static extension de.cdv.mauar.backend.generator.process.GeoJSONWriter.*

class PhotoLocationJSONGenerator implements ProcessorDefinitions {

	def static void main(String[] args) {
		val input = System.getProperty("user.dir") + "/res/coding-da-vinci-metadaten.csv"
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		val json = '''
			{
				«FOR values : valuesList.map[Pair.of(it, (POINT_PROCESSOR.apply(it, keys) as Point).coordinates)].filter[it.value !== null] SEPARATOR ","»
					"«ID_PROCESSOR.apply(values.key, keys) as String»": [«values.value.latitude»,«values.value.longitude»]
				«ENDFOR»
			}
		'''
		json.toString.writeFile("res/photolocations.json")
	}
}