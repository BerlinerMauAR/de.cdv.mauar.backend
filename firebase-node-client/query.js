var admin = require('firebase-admin');
var firebase = require('firebase');
var GeoFire = require('geofire');
var homedir = require('homedir');
var serviceAccount = require(homedir() + "/firebase/firebase.json");

firebase.initializeApp({
 "appName": "mauAR Client Demo",
 "credential": admin.credential.cert(serviceAccount),
 "authDomain": "mauar-cc91a.firebaseapp.com",
 "databaseURL": "https://mauar-cc91a.firebaseio.com/",
 "storageBucket": "mauar-cc91a.appspot.com"
}, "photos");

var geoRef = firebase.app("photos").database().ref('geofire');
var geoFire = new GeoFire(geoRef);

geoFire.get("F-015005").then(function(location) {
  if (location === null) {
    console.log("Provided key is not in GeoFire");
  }
  else {
    console.log("Provided key has a location of " + location);
  }
}, function(error) {
  console.log("Error: " + error);
});

var geoQuery = geoFire.query({
  center: [52.50818,13.39911],
  radius: 1.5
});

var onKeyEnteredRegistration = geoQuery.on("key_entered", function(key, location, distance) {
  console.log(key + " entered query at " + location + " (" + distance + " km from center)");
});

