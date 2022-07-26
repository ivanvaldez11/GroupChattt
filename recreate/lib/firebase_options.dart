import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;



class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAUZ4Hpt2FTZ4KcHe_46R3EBDwqglbwJGA',
    appId: '1:343659267573:web:87ecb41478462e89698cbc',
    messagingSenderId: '343659267573',
    projectId: 'chat-app-6c19b',
    authDomain: 'chat-app-6c19b.firebaseapp.com',
    storageBucket: 'chat-app-6c19b.appspot.com',
    measurementId: 'G-J8TR8PGJDC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsKUbrszFcENPjwsIWNVjy33vHVFumxi0',
    appId: '1:343659267573:android:9ba3cda35cd852bb698cbc',
    messagingSenderId: '343659267573',
    projectId: 'chat-app-6c19b',
    storageBucket: 'chat-app-6c19b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARr2xbLUGJbjEZbSoLgLwHAjfiSglOViU',
    appId: '1:343659267573:ios:ed5c277cb2556a3e698cbc',
    messagingSenderId: '343659267573',
    projectId: 'chat-app-6c19b',
    storageBucket: 'chat-app-6c19b.appspot.com',
    androidClientId: '343659267573-mcc953ohnaoahrdtt76pr5fqrfuf06nm.apps.googleusercontent.com',
    iosClientId: '343659267573-nvd2pnliseno31mispk86c0ucd9t17j3.apps.googleusercontent.com',
    iosBundleId: 'com.timelessfusionapps.smartTalk',
  );
}