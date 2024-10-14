// web/firebase-messaging-sw.js

importScripts(
  "https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js"
);

// Configurer votre projet Firebase
firebase.initializeApp({
  apiKey: "AIzaSyBfiY9UGzZQdfhQSq2XZS8vsUha9NbN39k",
  appId: "1:957530271324:web:5c51bd3b3ced51ae7d0099",
  messagingSenderId: "957530271324",
  projectId: "terrain-223",
  authDomain: "terrain-223.firebaseapp.com",
  storageBucket: "terrain-223.appspot.com",
});

// Initialiser Firebase Messaging
const messaging = firebase.messaging();

// Gérer les notifications reçues en arrière-plan
messaging.onBackgroundMessage(function (payload) {
  console.log(
    "[firebase-messaging-sw.js] Received background message ",
    payload
  );
  // Personnalisation de la notification
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
