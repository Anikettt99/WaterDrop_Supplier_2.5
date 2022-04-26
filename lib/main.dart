// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/splash_screen.dart';
import 'package:waterdrop_supplier/views/homepage/home_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'helper/helper.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high importance channel', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message showed up : ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String curVersion = "1.0.3";
//  bool isUpdateAvailable = false;
  bool userIsLoggedIn = false;
//  String downloadLink = "";
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  bool isVersionEqual(String newVersion, String currentVersion) {
    return newVersion.compareTo(currentVersion) == 0;
  }

  @override
  void initState() {
    /*dataBaseMethods.getAppURL().then((value) {
      //print(value);
      if (!isVersionEqual(value['appVersion'], curVersion)) {
        downloadLink = value['appLink'];
        print(downloadLink);
        setState(() {
          isUpdateAvailable = true;
        });
      }
      else{
        setState(() {
          isUpdateAvailable = false;
        });
      }
    });*/
    super.initState();
    getLoggedInState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    color: primaryColor,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });
  }

  getLoggedInState() async {
    //await HelperFunctions.saveUserLoggedInSharedPreference(false);
    await HelperFunctions.getUserLoggedInSharedPreference().then(
      (value) {
        if (value == null) {
          value = false;
          return;
        }
        setState(() {
          userIsLoggedIn = value!;
          print(userIsLoggedIn);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!);
      },
      title: 'WaterDrop Supplier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: userIsLoggedIn != null
          ? userIsLoggedIn
              ? HomePage()
              : SplashScreen()
          : Center(
              child: SplashScreen(),
            ),
    );
  }
}
