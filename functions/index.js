const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

// On sign up.
exports.setAdmin = functions.auth.user().onCreate(async (user) => {
    // Check if user meets role criteria.
    if (user.email && user.email == "abiudcantu@gmail.com") {
        console.log("Abiud set as admin");
        const customClaims = {
            role: "admin",
        };
        try {
            // Set custom user claims on this newly created user.
            await admin.auth().setCustomUserClaims(user.uid, customClaims);
            // Update firestore to notify client to force refresh.
            await admin
                .firestore()
                .collection("users")
                .doc(user.uid)
                .set({ role: "admin" }, { merge: true });
        } catch (error) {
            console.log(error);
        }
    } else {
        const customClaims = {
            role: "volunteer",
        };
        try {
            await admin.auth().setCustomUserClaims(user.uid, customClaims);
            await admin
                .firestore()
                .collection("users")
                .doc(user.uid)
                .set({ role: "volunteer" }, { merge: true });
        } catch (error) {
            console.log(error);
        }
    }
});

exports.setRole = functions.firestore
    .document("users/{uid}")
    .onUpdate(async (snapshot, context) => {
        const newRole = snapshot.after.data().role;
        const oldRole = snapshot.before.data().role;
        if (newRole != oldRole) {
            if (newRole == "admin") {
                const customClaims = {
                    role: "admin",
                };
                try {
                    await admin
                        .auth()
                        .setCustomUserClaims(context.params.uid, customClaims);
                } catch (error) {
                    console.log(error);
                }
            } else if (newRole == "farmer") {
                const customClaims = {
                    role: "farmer",
                };
                try {
                    await admin
                        .auth()
                        .setCustomUserClaims(context.params.uid, customClaims);
                } catch (error) {
                    console.log(error);
                }
            } else {
                const customClaims = {
                    role: "volunteer",
                };
                try {
                    await admin
                        .auth()
                        .setCustomUserClaims(context.params.uid, customClaims);
                } catch (error) {
                    console.log(error);
                }
            }
        }
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

// exports.aggregateProduct = functions.firestore
//     .document("products/{docId}")
//     .onCreate(async (change, context) => {
//         const statsRef = admin.firestore().collection("stats").doc("products");

//         await admin.firestore().runTransaction(async (transaction) => {
//             const statsDoc = await transaction.get(statsRef);

//             const newTotal = statsDoc.data().total + 1;

//             transaction.update(statsRef, {
//                 total: newTotal,
//             });
//         });
//     });

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
