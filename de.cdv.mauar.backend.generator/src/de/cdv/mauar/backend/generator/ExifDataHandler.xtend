package de.cdv.mauar.backend.generator

import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import org.apache.commons.imaging.ImageReadException
import org.apache.commons.imaging.ImageWriteException
import org.apache.commons.imaging.Imaging
import org.apache.commons.imaging.formats.jpeg.JpegImageMetadata
import org.apache.commons.imaging.formats.jpeg.exif.ExifRewriter
import org.apache.commons.imaging.formats.tiff.write.TiffOutputSet

class ExifDataHandler {

	static def void setExifGPSTag(File jpegImageFile, File dst, double longitude, double latitude) 
			throws IOException, ImageReadException, ImageWriteException {
		editExif(jpegImageFile, dst, [outputSet | outputSet.setGPSInDegrees(longitude, latitude)])
	}
	
	private static def void editExif(File jpegImageFile, File dst, (TiffOutputSet) => void operation) 
			throws IOException, ImageReadException, ImageWriteException {
		val fos = new FileOutputStream(dst)
		val os = new BufferedOutputStream(fos)
		try {
			val jpegMetadata = Imaging.getMetadata(jpegImageFile) as JpegImageMetadata
			val outputSet = jpegMetadata?.exif?.outputSet
			if (outputSet !== null) {
				operation.apply(outputSet)
				new ExifRewriter().updateExifMetadataLossless(jpegImageFile, os, outputSet)
			}
		} finally {
			if (fos !== null) fos.close
			if (os !== null) os.close
		}
	}	
}
