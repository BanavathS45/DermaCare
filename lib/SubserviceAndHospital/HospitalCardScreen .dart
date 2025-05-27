import 'package:cutomer_app/Modals/ServiceModal.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';

import '../ServiceView/ServiceDetailPage.dart';

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

  final List<Map<String, dynamic>> hospitalCards = [
    {
      "hospitalLogo":
          "https://thumbs.dreamstime.com/b/hospital-building-modern-parking-lot-59693686.jpg",
      "hospitalName": "City Hospital",
      "serviceName": "Skin Care",
      "subServiceName": "Acne Treatment",
      "cost": "₹1500",
      "recommended": true
    },
    {
      "hospitalLogo":
          "https://tse1.mm.bing.net/th/id/OIP.4ltnqFueQIIE-CudNSnT2QHaD3?cb=iwp1&w=843&h=441&rs=1&pid=ImgDetMain",
      "hospitalName": "Glow Clinic",
      "serviceName": "Hair Removal",
      "subServiceName": "Laser",
      "cost": "₹1800",
      "recommended": false
    },
    {
      "hospitalLogo":
          "https://tse1.mm.bing.net/th/id/OIP.tuWKtt16SGVcH1UXXkxDIgHaFC?cb=iwp1&w=1080&h=734&rs=1&pid=ImgDetMain",
      "hospitalName": "SkinGlow",
      "serviceName": "Skin Care",
      "subServiceName": "Acne Treatment",
      "cost": "₹1200",
      "recommended": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCards = hospitalCards.where((card) {
      final matchesSearch = card['subServiceName']
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          card['hospitalName'].toLowerCase().contains(searchText.toLowerCase());
      final isRecommended = !showRecommendedOnly || card['recommended'] == true;
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
                      hintText: "Search hospital or subservice",
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
              label: Text("Recommended Hospitals"),
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
              child: filteredCards.isEmpty
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
                                    selectedService: widget.selectedService!,
                                  ),
                                ),
                              );
                            } else {
                              // Handle the null case – show error, fallback page, or skip navigation
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Please select a service first')),
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
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          card['hospitalLogo'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
