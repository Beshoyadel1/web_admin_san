importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

const firebaseConfig = {
  apiKey: "AIzaSyB8Lixy-XF0V_UCTGCzUz0AEBzLgIP-7ik",
  appId: "1:567407553652:web:d510db5fa139b829b7b521",
  messagingSenderId: "567407553652",
  projectId: "sun-app-6c6af",
  authDomain: "sun-app-6c6af.firebaseapp.com",
  storageBucket: "sun-app-6c6af.firebasestorage.app",
  measurementId: "G-R3BVP1XBXZ",
};

if (!firebase.apps.length) {
  firebase.initializeApp(firebaseConfig);
}

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("[firebase-messaging-sw.js] Received background message for Admin: ", payload);

  const d = payload.data || {};
  const notif = payload.notification || {};

  const notificationTitle =
    notif.title ||
    d.title ||
    d.latintitle ||
    d.Title ||
    d.LatinTitle ||
    d.TITLE ||
    d.username ||
    d.fromusername ||
    d.sender ||
    "San Admin System";

  const notificationBody =
    notif.body ||
    d.body ||
    d.description ||
    d.latindesc ||
    d.Body ||
    d.Description ||
    d.LatinDesc ||
    d.message ||
    d.text ||
    d.content ||
    "";

  const notificationOptions = {
    body: notificationBody,
    icon: "/favicon.png",
    badge: "/favicon.png",
    data: d,
    tag: d.orderId || d.orderid || d.id || Date.now().toString(),
  };

  // 1. Broadcast background message to any open admin tab
  self.clients.matchAll({ type: "window", includeUncontrolled: true }).then((windowClients) => {
    for (let i = 0; i < windowClients.length; i++) {
      const client = windowClients[i];
      client.postMessage({
        isFcmBackgroundMessage: true,
        data: d,
        notification: {
          title: notificationTitle,
          body: notificationBody,
        },
      });
    }
  });

  // 2. Display native OS/browser notification banner
  return self.registration.showNotification(notificationTitle, notificationOptions);
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();

  const payloadData = event.notification.data || {};
  const urlToOpen = self.location.origin;

  event.waitUntil(
    self.clients
      .matchAll({ type: "window", includeUncontrolled: true })
      .then((windowClients) => {
        for (let i = 0; i < windowClients.length; i++) {
          const client = windowClients[i];

          // If tab is open on this origin/hostname
          if (
            client.url &&
            (client.url.includes(self.location.hostname) || client.url.includes(urlToOpen))
          ) {
            client.focus();

            // Send click payload to Flutter
            client.postMessage({
              isFcmClick: true,
              data: payloadData,
              notification: {
                title: event.notification.title,
                body: event.notification.body,
              },
            });
            return;
          }
        }

        // If no tab is open, open a new window
        if (self.clients.openWindow) {
          return self.clients.openWindow(urlToOpen);
        }
      })
  );
});

// Immediately activate service worker upon install and claim clients
self.addEventListener("install", (event) => {
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(self.clients.claim());
});

