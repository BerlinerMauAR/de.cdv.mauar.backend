var admin = require('firebase-admin');
var firebase = require('firebase');
var GeoFire = require('geofire');
var homedir = require('homedir');
var serviceAccount = require(homedir() + "/firebase/firebase.json");
var photolocations = require('./photolocations.json');

firebase.initializeApp({
 "appName": "mauAR Client Demo",
 "credential": admin.credential.cert(serviceAccount),
 "authDomain": "mauar-cc91a.firebaseapp.com",
 "databaseURL": "https://mauar-cc91a.firebaseio.com/",
 "storageBucket": "mauar-cc91a.appspot.com"
}, "photos");

var geoRef = firebase.app("photos").database().ref('geofire');
var geoFire = new GeoFire(geoRef);

var promises = Object.keys(photolocations).forEach(function(key) {
    return geoFire.set(key, photolocations[key]).then(function() {
      console.log(key + " initially set to [" + photolocations[key] + "]");
    });
});