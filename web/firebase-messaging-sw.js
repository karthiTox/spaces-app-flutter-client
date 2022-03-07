importScripts("https://www.gstatic.com/firebasejs/9.6.8/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.8/firebase-messaging.js");

const firebaseConfig = {
  apiKey: "AIzaSyDGc5x1BPMh3LbMkJ0YMSC2dMlgbL4GRJs",
  authDomain: "spaces-dc4e8.firebaseapp.com",
  projectId: "spaces-dc4e8",
  storageBucket: "spaces-dc4e8.appspot.com",
  messagingSenderId: "364364851396",
  appId: "1:364364851396:web:0f39e0ec68d6c12b884191",
  measurementId: "G-HY55PE3VM0",
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = 'Background Message Title';
  const notificationOptions = {
    body: 'Background Message body.',
    icon: '/firebase-logo.png'
  };

  self.registration.showNotification(notificationTitle,
    notificationOptions);
});
