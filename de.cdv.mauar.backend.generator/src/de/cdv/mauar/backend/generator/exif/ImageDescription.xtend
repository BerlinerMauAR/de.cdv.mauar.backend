package de.cdv.mauar.backend.generator.exif

import org.eclipse.xtend.lib.annotations.Data
import org.geojson.LngLatAlt
import de.oehme.xtend.contrib.Buildable

@Data
@Buildable
class ImageDescription {
	private val LngLatAlt coord
	private val String title
	private val String photographer
	private val String imageDescription
	private val String dateTime
	private val String comment
	private val String license
}