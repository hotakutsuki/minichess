// import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import {onDocumentCreated} from "firebase-functions/v2/firestore";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

// this is for v2
exports.sendNewMatchNotificationV2 = onDocumentCreated(
    "matches/{matchId}",
    (event) => {
      const matchId = event.params.matchId;
      console.log(`matchId: ${matchId}`);
      const match = event.data?.data();
      if (!match) {
        console.log("No match data found");
        return;
      }
      console.log(`match: ${JSON.stringify(match)}`);
      db.collection("users")
          .where("id", "==", match.hostPlayerId)
          .get()
          .then((userSnapshot) => {
            const user = userSnapshot.docs[0].data();
            console.log(`user: ${JSON.stringify(user)}`);
            const payload = {
              notification: {
                title: "New Challenge!",
                body: `${user.name || "Someone"} wants to play`,
              },
              data: {
                // Opcional: datos adicionales para Flutter
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                screen: "matches",
              },
            };
            db.collection("tokens")
                .get()
                .then((tokens) => {
                  const listTokens: Array<string> = tokens.docs.reduce(
                      (acc, cur) => [...acc, cur.data().token],
                        [] as string[]
                  );
                  console.log(`listTokens: ${listTokens}`);
                  const message = {
                    notification: payload.notification,
                    tokens: listTokens,
                  };
                  const response = fcm.sendEachForMulticast(message);
                  console.log(`response: ${JSON.stringify(response)}`);
                })
                .catch((error) => {
                  console.log(`Error getting tokens: ${error}`);
                });
          })
          .catch((error) => {
            console.log(`Error getting user: ${error}`);
          });
    }
);

// this is for v1
// exports.sendNewMatchNotification = functions.firestore
//     .document("matches/{newMatchId}")
//     .onCreate(async (snapshot) => {
//       const match = snapshot.data();
//       console.log(`match: ${JSON.stringify(match)}`);
//       const userSnapshot = await db.collection("users")
//           .where("id", "==", match.hostPlayerId)
//           .get();

//       const user = userSnapshot.docs[0].data();
//       console.log(`user: ${JSON.stringify(user)}`);
//       const payload: admin.messaging.MessagingPayload = {
//         notification: {
//           title: "New Challenge!",
//           body: `${user.name || "Someone"} wants to play`,
//           clickAction: "FLUTTER_NOTIFICATION_CLICK",
//         },
//       };

//       const tokens = await db.collection("tokens").get();
//       const listTokens: Array<string> = tokens
//           .docs
//           .reduce((acc, cur) => [...acc, cur.data().token], [] as string[]);
//       console.log(`listTokens: ${listTokens}`);
//       const response = await fcm.sendToDevice(listTokens, payload);
//       console.log(`response: ${JSON.stringify(response)}`);
//      const sendToTokenResponse = await fcm.sendToTopic("newMatches",payload);
//       console.log(`toTokenResponse: ${JSON.stringify(sendToTokenResponse)}`);
//       return;
//     });
