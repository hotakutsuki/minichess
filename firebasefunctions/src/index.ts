import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendNewMatchNotification = functions.firestore
    .document("matches/{newMatchId}")
    .onCreate(async (snapshot) => {
      const match = snapshot.data();
      console.log(`match: ${JSON.stringify(match)}`);
      const userSnapshot = await db.collection("users")
          .where("id", "==", match.hostPlayerId)
          .get();

      const user = userSnapshot.docs[0].data();
      console.log(`user: ${user}`);
      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: "New Challenge!",
          body: `${user.name || "Someone"} wants to play`,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      const tokens = await db.collection("tokens").get();
      const listTokens: Array<string> = tokens
          .docs
          .reduce((acc, cur) => [...acc, cur.data().token], [] as string[]);
      console.log(`listTokens: ${listTokens}`);
      const response = fcm.sendToDevice(listTokens, payload);
      console.log(`response: ${response}`);
      return fcm.sendToTopic("newMatches", payload);
    });
