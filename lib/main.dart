import 'package:cutomer_app/Notification/NotificationController.dart';
import 'package:cutomer_app/Notification/Notifications.dart';
import 'package:cutomer_app/Routes/Navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavigation/Appoinments/AppointmentController.dart';
import 'Controller/CustomerController.dart';
import 'Dashboard/DashBoardController.dart';
import 'Doctors/ListOfDoctors/DoctorController.dart';
import 'Doctors/Schedules/ScheduleController.dart';
import 'NetworkCheck/NetworkService.dart';
import 'ConfirmBooking/ConsultationController.dart';
import 'SigninSignUp/BiometricAuthScreen.dart';
import 'SigninSignUp/LoginScreen.dart';
import 'TreatmentAndServices/ServiceSelectionController.dart';
import 'Utils/Constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Handle terminated state tap
 
 RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  // Init PhonePe SDK
  await PhonePePaymentSdk.init("SANDBOX", null, "PGTESTPAYUAT", true);

  // Init Network Service
  NetworkService().initialize();

  // Init GetX Controllers
  Get.put(SelectedServicesController());
  Get.put(Dashboardcontroller());
  Get.put(Serviceselectioncontroller());
  Get.put(Consultationcontroller());
  Get.put(DoctorController());
  Get.put(ScheduleController());
  Get.put(AppointmentController());
  Get.put(NotificationController());

  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final isFirstLoginDone = prefs.getBool('isFirstLoginDone') ?? false;

  // Setup background notification tap handler
  // ✅ Must register controller BEFORE setting up listener
  final notificationController = Get.put(NotificationController());

  // ✅ Background notification tap
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    notificationController.handleNotification(message);
  });
  // ✅ Terminated state notification

  if (initialMessage != null) {
    notificationController.handleNotification(initialMessage);
  }
  // final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // void initLocalNotification() {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);

  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  // Launch App
  runApp(MyApp(
    isFirstLoginDone: isFirstLoginDone,
    initialMessage: initialMessage,
  ));
}

class MyApp extends StatelessWidget {
  final bool isFirstLoginDone;
  final RemoteMessage? initialMessage;

  const MyApp({
    super.key,
    required this.isFirstLoginDone,
    this.initialMessage,
  });

  @override
  Widget build(BuildContext context) {
    // Choose initial screen
    Widget homeScreen;

    if (initialMessage != null) {
      homeScreen = NotificationScreen();
    } else {
      homeScreen = isFirstLoginDone ? BiometricAuthScreen() : Loginscreen();
    }

    return GetMaterialApp(
      title: 'Derma Care',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: homeScreen,
      onGenerateRoute: onGenerateRoute,
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      fontFamily: 'LeagueSpartan',
      colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
      primaryColor: mainColor,
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF4C3C7D),
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
    );
  }
}
