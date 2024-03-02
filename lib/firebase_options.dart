// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBU3p06VxHlZVpv1FzBrxpHeHSKUO9VhYg',
    appId: '1:887412744042:web:b41f49c2be50ebafda0f13',
    messagingSenderId: '887412744042',
    projectId: 'niceroute-909bb',
    authDomain: 'niceroute-909bb.firebaseapp.com',
    storageBucket: 'niceroute-909bb.appspot.com',
    measurementId: 'G-41YV13NFEH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQRML1A5m0orWwRODLTf-Ifv4ivXaoPbc',
    appId: '1:887412744042:android:424eceff87741998da0f13',
    messagingSenderId: '887412744042',
    projectId: 'niceroute-909bb',
    storageBucket: 'niceroute-909bb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBR3z5hxH6wZMZpsE_bIdXdETvRHfLvgtA',
    appId: '1:887412744042:ios:011159dcb13a2a65da0f13',
    messagingSenderId: '887412744042',
    projectId: 'niceroute-909bb',
    storageBucket: 'niceroute-909bb.appspot.com',
    androidClientId:
        '887412744042-b6tu7d50qi4740kipf5a4m8tj17bcrbq.apps.googleusercontent.com',
    iosClientId:
        '887412744042-lh97j1t5mh0bu7q64ho9d4eeedtljhni.apps.googleusercontent.com',
    iosBundleId: 'com.example.niceroute',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBR3z5hxH6wZMZpsE_bIdXdETvRHfLvgtA',
    appId: '1:887412744042:ios:bbe89abde65daa89da0f13',
    messagingSenderId: '887412744042',
    projectId: 'niceroute-909bb',
    storageBucket: 'niceroute-909bb.appspot.com',
    androidClientId:
        '887412744042-b6tu7d50qi4740kipf5a4m8tj17bcrbq.apps.googleusercontent.com',
    iosClientId:
        '887412744042-vl8qk2gug71lacrj79nndkm50507hss2.apps.googleusercontent.com',
    iosBundleId: 'com.example.niceroute.RunnerTests',
  );
}