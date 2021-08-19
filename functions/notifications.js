const admin = require("firebase-admin");
const functions = require("firebase-functions");

const db = admin.firestore();
const fcm = admin.messaging();

exports.newMessage = functions.firestore
    .document("messages/{docId}")
    .onWrite(async (change, context) => {
        const fromId = change.after.data().lastMessage.idFrom;
        const toId = change.after.data().lastMessage.idTo;

        if (change.after.data().lastMessage.read === true) {
            return { success: true };
        }

        functions.logger.log("Message from:", fromId, "to:", toId);

        const quearySnapshot = await db
            .collection("users")
            .doc(toId)
            .collection("tokens")
            .get();

        const tokens = quearySnapshot.docs.map((snap) => snap.id);
        if (tokens.length === 0) {
            return functions.logger.log(
                "There are no notification tokens to send to."
            );
        }
        functions.logger.log(
            "There are",
            tokens.length,
            "tokens to send notifications to."
        );

        const payload = {
            notification: {
                title: fromId,
                body: change.after.data().lastMessage.content,
                tag: context.params.docId,
            },
            data: {
                route: "conversation",
                idFrom: fromId,
                idTo: toId,
                convId: context.params.docId,
                groupKey: context.params.docId,
            },
        };

        const options = {
            collapseKey: context.params.docId,
        };

        const response = await fcm.sendToDevice(tokens, payload, options);

        const tokensToRemove = [];

        response.results.forEach((result, index) => {
            const error = result.error;
            if (error) {
                functions.logger.error(
                    "Failure sending notification to",
                    tokens[index],
                    error
                );
                // Cleanup the tokens who are not registered anymore.
                if (
                    error.code === "messaging/invalid-registration-token" ||
                    error.code === "messaging/registration-token-not-registered"
                ) {
                    tokensToRemove.push(
                        db
                            .collection("users")
                            .doc(toId)
                            .collection("tokens")
                            .doc(tokens[index])
                            .remove()
                    );
                }
            }
        });
        return Promise.all(tokensToRemove);
    });
