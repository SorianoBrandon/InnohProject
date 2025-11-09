import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('Plataforma no soportada');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyChuRQY0he4WT_Kg19HolXuPsQGKYVGQKU",
    authDomain: "innohproject-d6b65.firebaseapp.com",
    projectId: "innohproject-d6b65",
    storageBucket: "innohproject-d6b65.firebasestorage.app",
    messagingSenderId: "333453859548",
    appId: "1:333453859548:web:3fd7dcc0b792f0acfdb219",
    measurementId: "G-2Z26XQ2C60",
  );
}
