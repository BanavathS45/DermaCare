// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController(text: 'Name');
//   final _idController = TextEditingController(text: 'ID');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Video Call App'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             children: [
//               TextFormField(controller: _nameController),
//               SizedBox(
//                 height: 20,
//               ),
//               TextFormField(controller: _idController),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Text('Call'),
//         onPressed: () {
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => CallPage(
//                 callID: _idController.text.toString(),
//                 uName: _nameController.text.toString()),
//           ));
//         },
//       ),
//     );
//   }
// }

// class CallPage extends StatelessWidget {
//   final String callID;
//   final String uName;

//   const CallPage({Key? key, required this.callID, required this.uName})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID: 1259972482, // Replace with your actual appID.
//       appSign:
//           "6a2d1369d816bfc6060da5ca2a5f4c48fe9f623727c7b1830c8fcc752cdc8e9a", // Replace with your actual appSign.
//       userID: '${uName}123',
//       userName: uName,
//       callID: callID,
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//         ..onHangUp = () {
//           Navigator.of(context).pop();
//         },
//     );
//   }
// }

// extension on ZegoUIKitPrebuiltCallConfig {
//   set onHangUp(Null Function() onHangUp) {}
// }
