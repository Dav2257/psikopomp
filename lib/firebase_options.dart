// File ini AKAN di-overwrite otomatis oleh perintah:
//   flutterfire configure
//
// Setelah kamu:
// 1. Buat project di https://console.firebase.google.com
// 2. Jalankan: flutterfire configure
//
// File ini adalah PLACEHOLDER sementara agar app bisa compile.
// Firestore TIDAK akan berfungsi sampai file ini di-replace dengan yang asli.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ⚠️ GANTI SEMUA NILAI DI BAWAH INI dengan output dari `flutterfire configure`

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCx3Mms473luQILArXbW-_fZDBOD-4G0ko',
    appId: '1:554226060927:web:13561e46e4ffc98951394a',
    messagingSenderId: '554226060927',
    projectId: 'psikopomp-c2d50',
    authDomain: 'psikopomp-c2d50.firebaseapp.com',
    storageBucket: 'psikopomp-c2d50.firebasestorage.app',
    measurementId: 'G-NJ023QHVBC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgejYQuD3mH1fARX2e-h7yQsuNXvdCWD4',
    appId: '1:554226060927:android:9bab9932b0de95f151394a',
    messagingSenderId: '554226060927',
    projectId: 'psikopomp-c2d50',
    storageBucket: 'psikopomp-c2d50.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDrgBdzNGiMzv6bGOVwW5EiKUU_i3WOkmM',
    appId: '1:554226060927:ios:0d43a97a3daa257251394a',
    messagingSenderId: '554226060927',
    projectId: 'psikopomp-c2d50',
    storageBucket: 'psikopomp-c2d50.firebasestorage.app',
    iosBundleId: 'com.example.psikopomp',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDrgBdzNGiMzv6bGOVwW5EiKUU_i3WOkmM',
    appId: '1:554226060927:ios:0d43a97a3daa257251394a',
    messagingSenderId: '554226060927',
    projectId: 'psikopomp-c2d50',
    storageBucket: 'psikopomp-c2d50.firebasestorage.app',
    iosBundleId: 'com.example.psikopomp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCx3Mms473luQILArXbW-_fZDBOD-4G0ko',
    appId: '1:554226060927:web:cb6e3b430eda636c51394a',
    messagingSenderId: '554226060927',
    projectId: 'psikopomp-c2d50',
    authDomain: 'psikopomp-c2d50.firebaseapp.com',
    storageBucket: 'psikopomp-c2d50.firebasestorage.app',
    measurementId: 'G-CGQBKTBQBS',
  );
}
