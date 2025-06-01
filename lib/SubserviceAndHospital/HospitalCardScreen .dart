import 'dart:convert';

import 'package:cutomer_app/Modals/ServiceModal.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../ServiceView/ServiceDetailPage.dart';
import 'HospitalService.dart';

class HospitalCardScreen extends StatefulWidget {
  final String mobileNumber;
  final String username;

  const HospitalCardScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.serviceId,
    required this.serviceName,
    required this.mobileNumber,
    required this.username,
    required this.selectedService,
    required this.services,
  });
  final String categoryName;
  final String categoryId;
  final String serviceId;
  final String serviceName;

  final SubService? selectedService;
  final Service services;
  @override
  _HospitalCardScreenState createState() => _HospitalCardScreenState();
}

class _HospitalCardScreenState extends State<HospitalCardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  bool showRecommendedOnly = false;
  List<Map<String, dynamic>> hospitalCards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print(
        "widget.selectedService!.subServiceId ${(widget.selectedService!.subServiceId)}");
    HospitalService()
        .fetchHospitalCards(widget.selectedService!.subServiceId)
        .then((data) {
      setState(() {
        hospitalCards = data;
        isLoading = false;
      });
    }).catchError((error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredCards = hospitalCards.where((card) {
      final matchesSearch = card['subServiceName']
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          card['hospitalName'].toLowerCase().contains(searchText.toLowerCase());
      final isRecommended = !showRecommendedOnly ||
          card['recommandation'] == true; //TODO: not working recommandation
      return matchesSearch && isRecommended;
    }).toList();

    return Scaffold(
      appBar: CommonHeader(
        title: "Hospitals & Services",
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search + Recommended Toggle
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search hospital ",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (val) => setState(() => searchText = val),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.star,
                  color: showRecommendedOnly ? Colors.white : Colors.teal),
              label: Text(" Click Here For Recommended Hospitals"),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    showRecommendedOnly ? Colors.teal : Colors.grey[300],
                foregroundColor:
                    showRecommendedOnly ? Colors.white : Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                setState(() {
                  showRecommendedOnly = !showRecommendedOnly;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            // Cards
            Expanded(
              child: isLoading
                  ? Center(
                      child: SpinKitFadingCircle(
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    )
                  : filteredCards.isEmpty
                      ? Center(child: Text("No results found."))
                      : ListView.builder(
                          itemCount: filteredCards.length,
                          itemBuilder: (context, index) {
                            final card = filteredCards[index];
                            return GestureDetector(
                              onTap: () {
                                if (widget.selectedService != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ServiceDetailsPage(
                                          mobileNumber: widget.mobileNumber,
                                          username: widget.username,
                                          selectedService:
                                              widget.selectedService!,
                                          hospitalName: card['hospitalName'],
                                          hospitalId: card['hospitalId']),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please select a service first')),
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.memory(
                                        base64Decode(card['hospitalLogo']),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'assets/images/fallback_logo.png');
                                        },
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(card['hospitalName'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 4),
                                            Text("Sub Service: " +
                                                card['subServiceName']),
                                            Text("Service: " +
                                                card['serviceName']),
                                            SizedBox(height: 8),
                                            Text(card['cost'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.teal)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
