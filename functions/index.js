const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

exports.setRole = functions.firestore
    .document("users/{docId}")
    .onCreate((snapshot, context) => {
        return snapshot.ref.update({
            role: "user",
        });
    });

exports.saveCopyOnDelete = functions.firestore
    .document("products/{docId}")
    .onUpdate((snapshot, context) => {
        return admin
            .firestore()
            .collection("products")
            .doc(context.params.docId)
            .collection("history")
            .add(snapshot.before.data());
    });
