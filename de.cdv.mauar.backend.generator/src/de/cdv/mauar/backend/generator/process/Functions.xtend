package de.cdv.mauar.backend.generator.process

import org.geojson.LngLatAlt

class Functions {

	def static handleMultipleValues(String line) {
		line.split("$$$").map[trim].filter[length>0]
	}

	private static String COORD_STR_START = "POINT "

	static def toLngLatAlt(String coord) {
		if (coord.startsWith(COORD_STR_START)) {
			var changed = coord.substring(COORD_STR_START.length)
			changed = changed.substring(1, changed.length - 1)
			val coords = changed.split(" ").map[Double.valueOf(it)]
			return new LngLatAlt(coords.get(0), coords.get(1))
		}
		return null
	}	
}