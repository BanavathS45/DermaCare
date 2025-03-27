// ignore: file_names
import 'package:cutomer_app/Address/AddAddress.dart';
 
import 'package:cutomer_app/Location/LocationScreen.dart';
import 'package:cutomer_app/SigninSignUp/LoginScreen.dart';
import 'package:cutomer_app/Screens/splashScreen.dart';
 
import 'package:cutomer_app/Terms/TermsAndConditionsScreen.dart';
import 'package:flutter/material.dart';

 
import '../Address/AddAddressScreen.dart';
import '../Address/AddAddressScreenself.dart';
import '../Address/AddAddresself.dart';
 
import '../Address/CurrentLocationScreen.dart';
 
import '../Help/HelpDesk.dart';
import '../Registration/RegisterScreen.dart';
 

var onGenerateRoute = (RouteSettings settings) {
  print('my routs: ${settings.name}');
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (builder) => const SplashScreen());
 
  

    case "/location":
      return MaterialPageRoute(builder: (builder) => LocationScreen());
    case "/login":
      return MaterialPageRoute(builder: (builder) => Loginscreen());

    case "/termsandcondition":
      return MaterialPageRoute(
          builder: (builder) => TermsAndConditionsScreen());

// termsandcondition

    case "/gethelp":
      return MaterialPageRoute(builder: (builder) => HelpDeskScreen());

    case "/registerScreen":
      final args = settings.arguments as List; // Expecting a List of arguments
      final fullName = args[0] as String; // Extract username
      final mobileNumber = args[1] as String; // Extract mobile number

      return MaterialPageRoute(
        builder: (_) => RegisterScreen(
          fullName: fullName,
          mobileNumber: mobileNumber, // Pass mobile number
        ),
      ); // Pass the fullName here
    case "/addresself":
      // Retrieve the arguments passed via Navigator.pushNamed
      final arguments = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => AddAddressScreenself(
          mobileNumber: arguments['mobileNumber'] as String,
          username: arguments['username'] as String, isLocation: arguments['isLocation'],
        ),
      );

    case "/addaddresself":
      final List<dynamic> args = settings.arguments as List<dynamic>;
      final String mobileNumber = args[0] as String;
      final String addressSearch = args[1] as String;
      final String username =  args[2] as String; // Ensure this corresponds to the address
      final bool isLocation =  args[3] as bool; // Ensure this corresponds to the address
      return MaterialPageRoute(
        builder: (context) => AddAddresself(
          mobileNumber: mobileNumber,
          username: username,
          addressSearch: '', isLocation: isLocation,
        ),
      );
    case "/address":
      // Retrieve the arguments passed via Navigator.pushNamed
      final args = settings.arguments as Map<String, dynamic>;

      return MaterialPageRoute(
        builder: (context) => AddAddressScreen(
          mobileNumber: args['mobileNumber'] as String,
          username: args['username'] as String,
        ),
      );

    case "/addaddress":
      final List<dynamic> args = settings.arguments as List<dynamic>;
      final String mobileNumber = args[0] as String;
      final String addressSearch = args[1] as String;
      final String username =
          args[2] as String; // Ensure this corresponds to the address
      return MaterialPageRoute(
        builder: (context) => AddAddress(
          mobileNumber: mobileNumber,
          username: username,
        ),
      );

    // case "/sevedaddress":
    //   return MaterialPageRoute(builder: (builder) => SaveAddressScreen());

    case "/currentloaction":
      final mobileNumber = settings.arguments as String;
      return MaterialPageRoute(
          builder: (builder) => CurrentLocationl(mobileNumber: mobileNumber));

    // case "/dashboard":
    //   return MaterialPageRoute(builder: (builder) => DashboardScreen());

// RegisterScreen
    default:
  }
};
