const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

exports.notifications = require("./notifications");
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

exports.weeklyReportHistory = functions.firestore
    .document("weeklyReports/{docId}")
    .onUpdate(async (change, context) => {
        const previousValue = change.before.data();
        const newValue = change.after.data();

        if (previousValue.availability && newValue.availability)
            if (
                previousValue.availability.updatedAt &&
                newValue.availability.updatedAt
            )
                if (
                    previousValue.availability.updatedAt._seconds !==
                    newValue.availability.updatedAt._seconds
                )
                    await admin
                        .firestore()
                        .collection("weeklyReports")
                        .doc(context.params.docId)
                        .collection("availabilityHistory")
                        .add(previousValue.availability);

        if (previousValue.order && newValue.order)
            if (previousValue.order.updatedAt && newValue.order.updatedAt)
                if (
                    previousValue.order.updatedAt._seconds !==
                    newValue.order.updatedAt._seconds
                )
                    await admin
                        .firestore()
                        .collection("weeklyReports")
                        .doc(context.params.docId)
                        .collection("orderHistory")
                        .add(previousValue.order);

        if (previousValue.harvest && newValue.harvest)
            if (previousValue.harvest.updatedAt && newValue.harvest.updatedAt)
                if (
                    previousValue.harvest.updatedAt._seconds !==
                    newValue.harvest.updatedAt._seconds
                )
                    await admin
                        .firestore()
                        .collection("weeklyReports")
                        .doc(context.params.docId)
                        .collection("harvestHistory")
                        .add(previousValue.harvest);

        if (previousValue.invoice && newValue.invoice)
            if (previousValue.invoice.updatedAt && newValue.invoice.updatedAt)
                if (
                    previousValue.invoice.updatedAt._seconds !==
                    newValue.invoice.updatedAt._seconds
                )
                    await admin
                        .firestore()
                        .collection("weeklyReports")
                        .doc(context.params.docId)
                        .collection("invoiceHistory")
                        .add(previousValue.invoice);
        return {
            success: true,
        };
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
