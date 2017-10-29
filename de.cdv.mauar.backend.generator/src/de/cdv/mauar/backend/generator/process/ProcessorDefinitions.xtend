package de.cdv.mauar.backend.generator.process

import org.geojson.Point

import static extension de.cdv.mauar.backend.generator.process.Functions.*

interface ProcessorDefinitions {

	val handleMultipleValuesFun = [String a | a.handleMultipleValues] 
	
	val PROP_PROCESSORS = newArrayList => [
		add(new Processor("kurztitel", "KURZTITEL"))
		add(new Processor("titel", "TITEL"))
		add(new Processor("fotograf", "FOTOGRAF", handleMultipleValuesFun))
		add(new Processor("datierungVon", "DATIERUNGVON"))
		add(new Processor("datierungBis", "DATIERUNGBIS"))
		add(new Processor("datierungKonkret", "DATIERUNGKONKRET"))
		add(new Processor("ortzeitbeschreibung", "ORTZEITBESCHREIBUNG"))
		add(new Processor("schlagwort", "SCHLAGWORT", handleMultipleValuesFun))
		add(new Processor("beschreibungMotiv", "BESCHREIBUNG_MOTIV"))
		add(new Processor("strassennameMotiv", "STRASSENNAME_MOTIV"))
		add(new Processor("stadtbezirk", "STADTBEZIRK", handleMultipleValuesFun))
		add(new Processor("url", "URL"))
		add(new Processor("datengeber", "DATENGEBER"))
		add(new Processor("isilDatengeber", "ISIL_DATENGEBER"))
		add(new Processor("lizenz", "LIZENZ"))
	] 
	
	val ID_PROCESSOR = new Processor("INV_NR")
	val POINT_PROCESSOR = new Processor("GEOKOORDINATEN_MOTIV", [String a | new Point(a.toLngLatAlt)])
	
}