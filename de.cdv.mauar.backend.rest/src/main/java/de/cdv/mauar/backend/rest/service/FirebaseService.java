package de.cdv.mauar.backend.rest.service;

import java.io.FileInputStream;

import com.firebase.geofire.GeoFire;
import com.firebase.geofire.GeoLocation;
import com.firebase.geofire.GeoQuery;
import com.firebase.geofire.GeoQueryEventListener;
import com.firebase.geofire.LocationCallback;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

// https://firebase.google.com/docs/database/admin/retrieve-data
public class FirebaseService {

	public static void main(String[] args) throws Exception {
		String path = System.getProperty("user.home") + "/firebase/firebase.json";
		FileInputStream serviceAccount = new FileInputStream(path);

		FirebaseOptions options = new FirebaseOptions.Builder()
		  .setCredentials(GoogleCredentials.fromStream(serviceAccount))
		  .setDatabaseUrl("https://mauar-cc91a.firebaseio.com/")
		  .setStorageBucket("mauar-cc91a.appspot.com")
		  .build();

		FirebaseApp photosApp = FirebaseApp.initializeApp(options, "photos");
		
		DatabaseReference ref = FirebaseDatabase.getInstance(photosApp).getReference("geofire");
		GeoFire geoFire = new GeoFire(ref);
		
//		geoFire.setLocation("F-015005", new GeoLocation(37.7853889, -122.4056973), new CompletionListener() {
//		    @Override
//		    public void onComplete(String key, DatabaseError error) {
//		        if (error != null) {
//		            System.err.println("There was an error saving the location to GeoFire: " + error);
//		        } else {
//		            System.out.println("Location saved on server successfully!");
//		        }
//		    }
//		});
		
		geoFire.getLocation("F-015005", new LocationCallback() {
		    @Override
		    public void onLocationResult(String key, GeoLocation location) {
		        if (location != null) {
		            System.out.println(String.format("The location for key %s is [%f,%f]", key, location.latitude, location.longitude));
		        } else {
		            System.out.println(String.format("There is no location for key %s in GeoFire", key));
		        }
		    }

		    @Override
		    public void onCancelled(DatabaseError databaseError) {
		        System.err.println("There was an error getting the GeoFire location: " + databaseError);
		    }
		});		
		
		GeoQuery geoQuery = geoFire.queryAtLocation(new GeoLocation(52.50818, 13.39911), 1.5);
		
		geoQuery.addGeoQueryEventListener(new GeoQueryEventListener() {
		    @Override
		    public void onKeyEntered(String key, GeoLocation location) {
		        System.out.println(String.format("Key %s entered the search area at [%f,%f]", key, location.latitude, location.longitude));
		    }

		    @Override
		    public void onKeyExited(String key) {
		        System.out.println(String.format("Key %s is no longer in the search area", key));
		    }

		    @Override
		    public void onKeyMoved(String key, GeoLocation location) {
		        System.out.println(String.format("Key %s moved within the search area to [%f,%f]", key, location.latitude, location.longitude));
		    }

		    @Override
		    public void onGeoQueryReady() {
		        System.out.println("All initial data has been loaded and events have been fired!");
		    }

		    @Override
		    public void onGeoQueryError(DatabaseError error) {
		        System.err.println("There was an error with this query: " + error);
		    }
		});		
		
//		DatabaseReference databaseReference = FirebaseDatabase.getInstance(photosApp).getReference();
//		
//		ValueEventListener listener = new ValueEventListener() {
//		    @Override
//		    public void onDataChange(DataSnapshot dataSnapshot) {
//		    	PhotoLocation photoLocation = dataSnapshot.getValue(PhotoLocation.class);
//		        System.out.println(dataSnapshot.getKey() + " is located " + photoLocation.getUrl() + " here.");
//		    }
//
//		    @Override
//		    public void onCancelled(DatabaseError databaseError) {
//		    }
//		};
//		databaseReference.addValueEventListener(listener);
//		//databaseReference.addListenerForSingleValueEvent(listener);
	}
}
