script type="module">
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.1.2/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.1.2/firebase-analytics.js";
  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  const firebaseConfig = {
    apiKey: "AIzaSyD_-zjHPaHAcgC6AeXqw_1JNaKVQKkqbro",
    authDomain: "plataformalsuprod-fcd49.firebaseapp.com",
    projectId: "plataformalsuprod-fcd49",
    storageBucket: "plataformalsuprod-fcd49.appspot.com",
    messagingSenderId: "773491729987",
    appId: "1:773491729987:web:2283687c1fe40af91216f6",
    measurementId: "G-HJB9YZZY04"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
</script>