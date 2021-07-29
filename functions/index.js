const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

exports.setRole = functions.firestore
    .document("users/{docId}")
    .onCreate((snapshot, context) => {
        return snapshot.ref.update({
            role: "volunteer",
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

exports.aggregateProduct = functions.firestore
    .document("products/{docId}")
    .onCreate(async (change, context) => {
        const statsRef = admin.firestore().collection("stats").doc("products");

        await admin.firestore().runTransaction(async (transaction) => {
            const statsDoc = await transaction.get(statsRef);

            const newTotal = statsDoc.data().total + 1;

            transaction.update(statsRef, {
                total: newTotal,
            });
        });
    });

exports.deleteProductHistory = functions.firestore
    .document("products/{docId}")
    .onDelete((snapshot, context) => {
        const collectionRef = admin
            .firestore()
            .collection("products")
            .doc(context.params.docId)
            .collection("history");

        var promises = [];

        return collectionRef
            .get()
            .then((qs) => {
                qs.forEach((docSnapshot) => {
                    promises.push(docSnapshot.ref.delete());
                });
                return Promise.all(promises);
            })
            .catch((error) => {
                console.log(error);
                return false;
            });
    });
