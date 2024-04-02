const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.createUserDocument = functions.auth.user().onCreate((user) => {
    const db = admin.firestore();
    const userRef = db.collection('users').doc(user.uid);

    // Set the initial data for the new user document
    return userRef.set({
        userId: user.uid,
        email: user.email,
        displayName: user.displayName,
        favorites: [],
    });
});
