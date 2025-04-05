import 'package:cutomer_app/Routes/Navigation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import 'BottomNavigation/BottomNavigation.dart';
import 'ConfirmBooking/ConfirmBookingController.dart';
import 'Controller/CustomerController.dart';
import 'CustomerRating/CustomerRating.dart';
import 'Dashboard/DashBoardController.dart';
import 'Doctors/DoctorInputData.dart';
import 'Doctors/ListOfDoctors/DoctorController.dart';
import 'Doctors/Schedules/ScheduleController.dart';
import 'Help/HelpDesk.dart';
import 'Loading/FullScreeenLoader.dart';
import 'NetworkCheck/NetworkService.dart';
import 'Registration/RegisterScreen.dart';
import 'ConfirmBooking/ConsultationController.dart';
import 'ConfirmBooking/Consultations.dart';

import 'Screens/splashScreen.dart';
import 'SigninSignUp/LoginScreen.dart';
import 'TreatmentAndServices/ServiceSelectionController.dart';
import 'Utils/Constant.dart';
import 'Utils/CountryAndState.dart';
import 'Utils/InvoiceDownload.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PhonePePaymentSdk.init(
    "SANDBOX", // or "PRODUCTION"
    null,
    "PGTESTPAYUAT",
    true,
  );
  NetworkService().initialize();

  Get.put(SelectedServicesController());
  Get.put(Dashboardcontroller());
  Get.put(Serviceselectioncontroller());
  Get.put(Consultationcontroller());
  Get.put(DoctorController());
  Get.put(ScheduleController()); // ✅ FIXED// 👈 This registers it eagerly
  Get.put(Confirmbookingcontroller()); // ✅ FIXED// 👈 This registers it eagerly
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Get.put(SelectedServicesController());
    // Get.put(Dashboardcontroller());
    // Get.put(Serviceselectioncontroller());
    // Get.put(Consultationcontroller());
    // Get.put(DoctorController());

    return GetMaterialApp(
        title: 'Derma Care',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'LeagueSpartan',
          colorScheme: ColorScheme.fromSeed(
            seedColor: mainColor, // Use #4C3C7D as the seed color
          ),
          primaryColor: mainColor, // Explicitly set the primary color
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4C3C7D), //ppBar background color
            titleTextStyle: TextStyle(
              color: Colors.white, // White text for better contrast
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white), // White icons
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFF4C3C7D), // Button background color
            textTheme:
                ButtonTextTheme.primary, // Ensure text is styled properly
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: mainColor,
            foregroundColor: Colors.white, // FAB background color
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color(0xFF6A5B94), // Set ElevatedButton background color
              foregroundColor: Colors.white, // Set text color to white
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Optional: Rounded corners
              ),
            ),
          ),
          scaffoldBackgroundColor:
              Colors.white, // Set scaffold background to white
          useMaterial3: true, // Use Material Design 3
        ),
        // home: BottomNavController(
        //   mobileNumber: "7842259803",
        //   username: "prashanth",
        //   index: 0,
        // ),
        home: ConsultationsType(
          username: 'prashanth',
          mobileNumber: '7842259803',
        )
        // home: FullscreenLoader(
        //   message: 'Your data is being sent securely.\nPlease wait...',
        //   logoPath: 'assets/surecare_launcher.png',
        // ),
        // home: DoctorProfileForm()
        // home: ConsultationsType(mobileNumber: '7842259803', username: 'prashanth',)
        // home: InvoicePage(bookingDetails: null,)
        // home: StateAndCity(
        //   title: "State and City",
        // ) // TODO:Tempary
        // onGenerateRoute: onGenerateRoute,
        );
  }
}
