// import 'package:flutter/material.dart';
// import 'package:upi_india/upi_india.dart';


// class UpiPaymentPage extends StatefulWidget {
//   @override
//   _UpiPaymentPageState createState() => _UpiPaymentPageState();
// }

// class _UpiPaymentPageState extends State<UpiPaymentPage> {
//   UpiIndia _upiIndia = UpiIndia();
//   late Future<List<UpiApp>> apps;

//   final String upiId = "7842259803@ybl"; // Set your clinic UPI ID here
//   final double amount = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     apps = _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
//   }

//   void _startTransaction(UpiApp app) async {
//     UpiResponse response = await _upiIndia.startTransaction(
//       app: app,
//       receiverUpiId: upiId,
//       receiverName: "Clinic Payment",
//       transactionRefId: "TXN-${DateTime.now().millisecondsSinceEpoch}",
//       transactionNote: "Clinic Consultation",
//       amount: amount,
//     );

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("Payment Status"),
//         content: Text("Status: ${response.status}\nTransaction ID: ${response.transactionId}"),
//         actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
//       ),
//     );
//   }

//   void _showUpiApps() {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => FutureBuilder<List<UpiApp>>(
//         future: apps,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//           if (snapshot.data!.isEmpty) return Center(child: Text("No UPI apps found"));

//           return ListView(
//             children: snapshot.data!.map((app) {
//               return ListTile(
//                 leading: Image.memory(app.icon, height: 40),
//                 title: Text(app.name),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _startTransaction(app);
//                 },
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Pay Clinic")),
//       body: Center(
//         child: ElevatedButton(
//           child: Text("Pay ₹$amount"),
//           onPressed: _showUpiApps,
//         ),
//       ),
//     );
//   }
// }