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
      console.log(`match host id: ${match.hostPlayerId}`);
      const userSnapshot = await db.collection("users")
          .doc(match.hostPlayerId)
          .get();

      console.log(`user snapshot: ${userSnapshot}`);
      const user = userSnapshot.data();
      console.log(`user: ${user}`);
      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: "New Challenge!",
          body: `${user?.name || "Someone"} wants to play`,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      const tokens = await db.collection("tokens").get();
      const listTokens: Array<string> = tokens
          .docs
          .reduce((acc, cur) => [...acc, cur.data().token], [] as string[]);
      console.log(listTokens);
      fcm.sendToDevice(listTokens, payload);
      return fcm.sendToTopic("newMatches", payload);
    });
