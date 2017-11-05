package de.cdv.mauar.backend.generator.exif

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
import org.apache.commons.imaging.formats.tiff.constants.ExifTagConstants
import org.apache.commons.imaging.formats.tiff.constants.GpsTagConstants
import org.apache.commons.imaging.formats.tiff.constants.TiffTagConstants
import org.apache.commons.imaging.formats.tiff.fieldtypes.FieldType
import org.apache.commons.imaging.formats.tiff.taginfos.TagInfoAscii
import org.apache.commons.imaging.formats.tiff.taginfos.TagInfoGpsText
import org.apache.commons.imaging.formats.tiff.write.TiffOutputField
import org.apache.commons.imaging.formats.tiff.write.TiffOutputSet
import java.util.Map
import java.util.HashMap
import org.apache.commons.imaging.ImagingConstants

class ExifDataHandler {

	static def void setExifData(File jpegImageFile, File dst, ImageDescription imgDesc) throws IOException, ImageReadException, ImageWriteException {
		editExif(jpegImageFile, dst, [outputSet |
			if(imgDesc.coord !== null) {
				outputSet.setGPSInDegrees(imgDesc.coord.longitude, imgDesc.coord.latitude)
			}
			jpegImageFile.addAsciiField(TiffTagConstants.TIFF_TAG_DOCUMENT_NAME, imgDesc.title, outputSet);
			jpegImageFile.addAsciiField(TiffTagConstants.TIFF_TAG_ARTIST, imgDesc.photographer, outputSet); 			
			jpegImageFile.addAsciiField(TiffTagConstants.TIFF_TAG_IMAGE_DESCRIPTION, imgDesc.imageDescription, outputSet);
			jpegImageFile.addAsciiField(TiffTagConstants.TIFF_TAG_DATE_TIME, imgDesc.dateTime, outputSet);
			jpegImageFile.addAsciiField(ExifTagConstants.EXIF_TAG_USER_COMMENT, imgDesc.comment, outputSet); 			
			jpegImageFile.addAsciiField(TiffTagConstants.TIFF_TAG_COPYRIGHT, imgDesc.license, outputSet);			 			
		])
	}

	private def static void addAsciiField(File jpegImageFile, TagInfoAscii tagInfo, String content, TiffOutputSet outputSet) {
		val existingField = outputSet.findField(tagInfo);
		if(existingField === null) {
			val bytes = tagInfo.encodeValue(FieldType.ASCII, content, outputSet.byteOrder); 
			val field = new TiffOutputField(tagInfo, tagInfo.dataTypes.get(0), bytes.length, bytes); 
			outputSet.getOrCreateRootDirectory().add(field)
		} else {
			System.err.println(tagInfo.name + " already exists for " + jpegImageFile.absolutePath)
		}
	}
	
	private def static void addAsciiField(File jpegImageFile, TagInfoGpsText tagInfo, String content, TiffOutputSet outputSet) {
		val existingField = outputSet.findField(tagInfo);
		if(existingField === null) {
			val bytes = tagInfo.encodeValue(FieldType.ASCII, content, outputSet.byteOrder); 
			val field = new TiffOutputField(tagInfo, tagInfo.dataTypes.get(0), bytes.length, bytes); 
			outputSet.getOrCreateRootDirectory().add(field)
		} else {
			System.err.println(tagInfo.name + " already exists for " + jpegImageFile.absolutePath)
		}
	}

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
			val Map<String, Object> params = new HashMap
			params.put(ImagingConstants.PARAM_KEY_READ_THUMBNAILS, Boolean.FALSE)
			val jpegMetadata = Imaging.getMetadata(jpegImageFile, params) as JpegImageMetadata
			val outputSet = jpegMetadata?.exif?.outputSet
			if (outputSet !== null) {
				operation.apply(outputSet)
				new ExifRewriter().updateExifMetadataLossless(jpegImageFile, os, outputSet)
			}
		} catch (ImageReadException ire) {
            System.err.println(ire.message + " for " + jpegImageFile.absolutePath)
            if(dst.exists) {
            	dst.deleteOnExit
            }
        } catch (IOException ioe) {
            System.err.println(ioe.message + " for " + jpegImageFile.absolutePath)
            if(dst.exists) {
            	dst.deleteOnExit
            }
        } finally {
			if (fos !== null) fos.close
			if (os !== null) os.close
		}
	}	
}
