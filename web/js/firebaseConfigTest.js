  script type="module">
    // Import the functions you need from the SDKs you need
    import { initializeApp } from "https://www.gstatic.com/firebasejs/9.1.2/firebase-app.js";
    import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.1.2/firebase-analytics.js";
    // TODO: Add SDKs for Firebase products that you want to use
    // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  const firebaseConfig = {
    apiKey: "AIzaSyCFvLAysrO3XsPlxI409XEFzmSSqieqH1U",
    authDomain: "plataformalsu-bd176.firebaseapp.com",
    projectId: "plataformalsu-bd176",
    storageBucket: "plataformalsu-bd176.appspot.com",
    messagingSenderId: "1051905371406",
    appId: "1:1051905371406:web:9602580022090abb1a3b5f",
    measurementId: "G-GVDQ6NQ78L"
  };

    // Initialize Firebase
    const app = initializeApp(firebaseConfig);
    const analytics = getAnalytics(app);
  </script>