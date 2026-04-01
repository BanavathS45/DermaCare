import 'dart:convert';

import 'package:cutomer_app/APIs/BaseUrl.dart';

import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../Doctors/ListOfDoctors/DoctorController.dart';
import '../../Doctors/ListOfDoctors/DoctorModel.dart';
import '../../Doctors/RatingAndFeedback/RatingAndFeedback.dart';

import 'package:http/http.dart' as http;

// adjust the import to your model path

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: 'Doctor Profile',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar and Name Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: ClipOval(
                      child: Center(
                        child: Image.asset(
                          "assets/DermaText.png",
                          width: 100, // adjust size as needed
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Banavath Prashnath",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: mainColor)),
                        const SizedBox(height: 4),
                        Text(
                          "Customer ID : CUS_002",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: secondaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Divider(
              height: 1,
            ),

            // Details Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  _buildDetailTile(Icons.call, "Mobile Number", "7842259803"),
                  _buildDetailTile(
                      Icons.email, "Email ID", "prashanthr803@gmail.com"),
                  _buildDetailTile(Icons.account_circle, "Gender", "Male"),
                  _buildDetailTile(Icons.cake, "Age", "20 Yrs"),
                  _buildDetailTile(
                      Icons.confirmation_number, "Refferal Code", "123456"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'BACK',
              style: TextStyle(color: mainColor),
            )),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: mainColor,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: mainColor)),
      subtitle: Text(subtitle,
          style: const TextStyle(color: secondaryColor, fontSize: 14)),
      dense: true,
    );
  }
}

class HelpScreen extends StatelessWidget {
  HelpScreen({
    super.key,
  });

  final String phone = "+91 7842259803";
  final String email = "support@uditcometech.com";
  final String address =
      "Pakricorn Technology, Road Number 10, Hyderabad, Telangana 500097";
  final String website = "https://uditcosmetech.com";
  String get mapsUrl =>
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  final String chatMessage = "Hello! I need help from Udit Cometech Support";

  String get whatsappUrl =>
      "https://wa.me/${phone.replaceAll("+", "")}?text=${Uri.encodeComponent(chatMessage)}";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CommonHeader(
          title: "Help & Contact",
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/DermaText.png",
                  width: 100, // adjust size as needed
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Need assistance? Reach out to Udit Cometech for support.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              _buildTile(
                icon: Icons.phone,
                title: "Call Us",
                subtitle: phone,
                onTap: () => _launchURL("tel:$phone"),
              ),
              _buildTile(
                icon: FontAwesome.whatsapp,
                title: "WhatsApp Chat",
                subtitle: phone,
                onTap: () => _launchURL(whatsappUrl),
              ),
              _buildTile(
                icon: Icons.email,
                title: "Email",
                subtitle: email,
                onTap: () => _launchURL("mailto:$email"),
              ),
              _buildTile(
                icon: Icons.location_on,
                title: "Address",
                subtitle: address,
                onTap: () => _launchURL(mapsUrl),
              ),
              _buildTile(
                icon: Icons.language,
                title: "Website",
                subtitle: website,
                onTap: () => _launchURL(website),
              ),
            ],
          ),
        ),
      );

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      leading: Icon(icon, size: 28, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
