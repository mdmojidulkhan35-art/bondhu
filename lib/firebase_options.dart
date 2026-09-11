import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Bondhu Web is not configured yet.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Bondhu is currently configured for Android only.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBifNo62Vm2f9o3KOt0NbxMVJaKjR1PcmM',
    appId: '1:772768166222:android:fcb7c5695caa1400872e1f',
    messagingSenderId: '772768166222',
    projectId: 'bondhu-cf2df',
    storageBucket: 'bondhu-cf2df.firebasestorage.app',
    databaseURL:
        'https://bondhu-cf2df-default-rtdb.firebaseio.com',
  );
}
