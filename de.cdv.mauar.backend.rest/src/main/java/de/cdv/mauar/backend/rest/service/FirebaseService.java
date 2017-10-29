package de.cdv.mauar.backend.rest.service;

import java.io.FileInputStream;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

// https://firebase.google.com/docs/database/admin/retrieve-data
public class FirebaseService {

	public static void main(String[] args) throws Exception {
		String path = System.getProperty("user.home") + "/firebase/firebase.json";
		FileInputStream serviceAccount = new FileInputStream(path);

		FirebaseOptions options = new FirebaseOptions.Builder()
		  .setCredentials(GoogleCredentials.fromStream(serviceAccount))
		  .setDatabaseUrl("https://mauar-cc91a.firebaseio.com/")
		  .setStorageBucket("photos")
		  .build();

		FirebaseApp photosApp = FirebaseApp.initializeApp(options, "photos");
		System.out.println(photosApp.getName());
		
		DatabaseReference databaseReference = FirebaseDatabase.getInstance(photosApp).getReference();
		
		ValueEventListener listener = new ValueEventListener() {
		    @Override
		    public void onDataChange(DataSnapshot dataSnapshot) {
		    	PhotoLocation photoLocation = dataSnapshot.getValue(PhotoLocation.class);
		        System.out.println(dataSnapshot.getKey() + " is located " + photoLocation.getUrl() + " here.");
		    }

		    @Override
		    public void onCancelled(DatabaseError databaseError) {
		    }
		};
		databaseReference.addValueEventListener(listener);
		//databaseReference.addListenerForSingleValueEvent(listener);
	}
}
