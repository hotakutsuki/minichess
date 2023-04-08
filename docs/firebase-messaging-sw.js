importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyDPLBIy66w4VZi00U81tOWTE6UM9ESJVow',
  appId: '1:733138640689:web:47d24419fd734df97cda10',
  messagingSenderId: '733138640689',
  projectId: 'minichess-34a02',
  authDomain: 'minichess-34a02.firebaseapp.com',
  databaseURL:
      'https://minichess-34a02-default-rtdb.firebaseio.com/',
  storageBucket: 'minichess-34a02.appspot.com',
  measurementId: 'G-P2N0RVSCTJ',
});

// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});