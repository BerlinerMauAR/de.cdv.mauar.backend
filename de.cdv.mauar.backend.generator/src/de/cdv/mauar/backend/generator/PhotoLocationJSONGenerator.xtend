package de.cdv.mauar.backend.generator

import de.cdv.mauar.backend.generator.process.Processor
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
		val urlProcessor = new Processor("URL")
		val json = '''
		{
			«FOR values : valuesList SEPARATOR ","»
				«val coords = (POINT_PROCESSOR.apply(values, keys) as Point).coordinates»
				"«ID_PROCESSOR.apply(values, keys) as String»": {
					"url": "«urlProcessor.apply(values, keys) as String»"«
					IF coords !== null»,
					"coord": [«coords.latitude»,«coords.longitude»]
					«ELSE»
					
					«ENDIF»
				}
			«ENDFOR»
		}
		'''
		json.toString.writeFile("res/photolocations.json")
	}
}