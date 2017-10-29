package de.cdv.mauar.backend.generator

import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import org.apache.commons.imaging.ImageReadException
import org.apache.commons.imaging.ImageWriteException
import org.apache.commons.imaging.Imaging
import org.apache.commons.imaging.common.RationalNumber
import org.apache.commons.imaging.formats.jpeg.JpegImageMetadata
import org.apache.commons.imaging.formats.jpeg.exif.ExifRewriter
import org.apache.commons.imaging.formats.tiff.constants.GpsTagConstants
import org.apache.commons.imaging.formats.tiff.write.TiffOutputSet

class ExifDataHandler {

	static def void setExifGPSTag(File jpegImageFile, File dst, double longitude, double latitude) 
			throws IOException, ImageReadException, ImageWriteException {
		editExif(jpegImageFile, dst, [outputSet | outputSet.setGPSInDegrees(longitude, latitude)])
	}

	static def void setExifAltitude(File jpegImageFile, File dst, double altitude) 
			throws IOException, ImageReadException, ImageWriteException {
		editExif(jpegImageFile, dst, [outputSet | outputSet.GPSDirectory.add(
			GpsTagConstants.GPS_TAG_GPS_ALTITUDE, RationalNumber.valueOf(altitude)
		)])
	}

	// value range: 0.00 to 359.99.
	static def void setExifImageDirection(File jpegImageFile, File dst, double imageDirection) 
			throws IOException, ImageReadException, ImageWriteException {
		editExif(jpegImageFile, dst, [outputSet | outputSet.GPSDirectory.add(
			GpsTagConstants.GPS_TAG_GPS_IMG_DIRECTION, RationalNumber.valueOf(imageDirection)
		)])
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
