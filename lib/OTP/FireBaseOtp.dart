// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class OTPLoginScreen extends StatefulWidget {
//   @override
//   _OTPLoginScreenState createState() => _OTPLoginScreenState();
// }

// class _OTPLoginScreenState extends State<OTPLoginScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();

//   String verificationId = '';
//   bool codeSent = false;

//   FirebaseAuth _auth = FirebaseAuth.instance;

//   void sendOTP() async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneController.text,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Auto-retrieval or instant verification
//         await _auth.signInWithCredential(credential);
//         print("Auto-verified!");
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print('Verification Failed: ${e.message}');
//       },
//       codeSent: (String verId, int? resendToken) {
//         setState(() {
//           verificationId = verId;
//           codeSent = true;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verId) {
//         verificationId = verId;
//       },
//     );
//   }

//   void verifyOTP() async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: otpController.text,
//     );

//     try {
//       UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       print("User signed in: ${userCredential.user?.uid}");
//     } catch (e) {
//       print("Invalid OTP");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Firebase OTP Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number (+91xxxxxxxxxx)',
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             if (codeSent)
//               TextField(
//                 controller: otpController,
//                 decoration: InputDecoration(labelText: 'Enter OTP'),
//               ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: codeSent ? verifyOTP : sendOTP,
//               child: Text(codeSent ? 'Verify OTP' : 'Send OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
