import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';
import 'package:cutomer_app/Utils/Header.dart'; // Custom header from your project

class UpiPaymentPage extends StatefulWidget {
  @override
  _UpiPaymentPageState createState() => _UpiPaymentPageState();
}

class _UpiPaymentPageState extends State<UpiPaymentPage> {
  UpiIndia _upiIndia = UpiIndia();
  late Future<List<UpiApp>> apps;

  final String upiId = "9148986699@ybl"; // Replace with clinic's UPI ID
  final double amount = 1.0;

  @override
  void initState() {
    super.initState();
    apps = _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
    apps.then((value) {
      print("UPI Apps found: ${value.map((e) => e.name).toList()}");
    }).catchError((e) {
      print("Error fetching UPI apps: $e");
    });
  }

  void _startTransaction(UpiApp app) async {
    print("Starting transaction with ${app.name}");

    try {
      UpiResponse response = await _upiIndia.startTransaction(
        app: app,
        receiverUpiId: upiId,
        receiverName: "Clinic Payment",
        transactionRefId: "TXN-${DateTime.now().millisecondsSinceEpoch}",
        transactionNote: "Clinic Consultation",
        amount: amount,
      );

      print("Transaction Status: ${response.status}");
      print("Transaction ID: ${response.transactionId}");

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Payment Status"),
          content: Text(
            "Status: ${response.status}\nTransaction ID: ${response.transactionId ?? 'N/A'}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      print("Transaction failed: $e");

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Error"),
          content: Text(
            "Transaction failed due to security restrictions.\nYou can also pay manually to:\n\nUPI ID: $upiId\nAmount: ₹$amount",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
    }
  }

  void _showUpiApps() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return FutureBuilder<List<UpiApp>>(
            future: apps,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print("Snapshot error: ${snapshot.error}");
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No UPI apps found"));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet_rounded, size: 28),
                        SizedBox(width: 10),
                        Text(
                          "Choose UPI App",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final app = snapshot.data![index];
                        return ListTile(
                          leading: Image.memory(app.icon, height: 40),
                          title: Text(app.name),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.pop(context);
                            _startTransaction(app);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: "Pay Clinic",
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Pay ₹$amount"),
          onPressed: _showUpiApps,
        ),
      ),
    );
  }
}
