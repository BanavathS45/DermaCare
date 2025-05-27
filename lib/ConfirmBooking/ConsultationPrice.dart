import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorScreen.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';

class ConsultationPrice extends StatefulWidget {
  final String mobileNumber;
  final String username;
  final String consulationType;
  final String categoryName;
  final String categoryId;
  final String serviceId;
  final String serviceName;
  final String subserviceName;
  final String subserviceid;

  const ConsultationPrice({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.serviceId,
    required this.serviceName,
    required this.mobileNumber,
    required this.username,
    required this.subserviceName,
    required this.subserviceid,
    required this.consulationType,
  });

  @override
  _ConsultationPriceState createState() => _ConsultationPriceState();
}

class _ConsultationPriceState extends State<ConsultationPrice> {
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
      "consultationType": "In-Clinic",
      "cost": "₹1500",
      "recommended": true
    },
    {
      "hospitalLogo":
          "https://tse1.mm.bing.net/th/id/OIP.4ltnqFueQIIE-CudNSnT2QHaD3?cb=iwp1",
      "hospitalName": "Glow Clinic",
      "serviceName": "Hair Removal",
      "subServiceName": "Laser",
      "consultationType": "Video",
      "cost": "₹1800",
      "recommended": false
    },
    {
      "hospitalLogo":
          "https://tse1.mm.bing.net/th/id/OIP.tuWKtt16SGVcH1UXXkxDIgHaFC?cb=iwp1",
      "hospitalName": "SkinGlow",
      "serviceName": "Skin Care",
      "subServiceName": "Acne Treatment",
      "consultationType": "In-Clinic",
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
      appBar: CommonHeader(title: "Hospitals & Services"),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search bar
            TextField(
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
            SizedBox(height: 12),

            // Recommended toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      showRecommendedOnly = !showRecommendedOnly;
                    });
                  },
                  icon: Icon(
                    showRecommendedOnly
                        ? Icons.check_circle
                        : Icons.star_border,
                    color: showRecommendedOnly ? Colors.white : Colors.teal,
                  ),
                  label: Text(
                    showRecommendedOnly
                        ? "Showing Recommended"
                        : "Recommended Hospitals",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        showRecommendedOnly ? Colors.teal : Colors.grey[300],
                    foregroundColor:
                        showRecommendedOnly ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    elevation: 2,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Hospital cards
            Expanded(
              child: filteredCards.isEmpty
                  ? Center(child: Text("No results found."))
                  : ListView.builder(
                      itemCount: filteredCards.length,
                      itemBuilder: (context, index) {
                        final card = filteredCards[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Doctorscreen(
                                  mobileNumber: widget.mobileNumber,
                                  username: widget.username,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    card['hospitalLogo'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(card['hospitalName'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        SizedBox(height: 4),
                                        Text("Service: ${card['serviceName']}"),
                                        Text(
                                            "Subservice: ${card['subServiceName']}"),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              widget.consulationType,
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              card['cost'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
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
    );
  }
}
