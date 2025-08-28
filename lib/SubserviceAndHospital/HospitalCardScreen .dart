import 'dart:convert';

import 'package:cutomer_app/Modals/ServiceModal.dart';
import 'package:cutomer_app/SubserviceAndHospital/HospitalCardModel.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final SubServiceAdmin? selectedService;
  final Service services;
  @override
  _HospitalCardScreenState createState() => _HospitalCardScreenState();
}

class _HospitalCardScreenState extends State<HospitalCardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  bool showRecommendedOnly = false;
  List<HospitalCardModel> hospitalCards = [];
  bool isLoading = true;

  @override
  @override
  void initState() {
    super.initState();
    fetchHospitalCards();
  }

  void fetchHospitalCards() async {
    setState(() {
      isLoading = true; // show loading
    });

    try {
      final data = await HospitalService()
          .fetchHospitalCards(widget.selectedService!.subServiceId);

      final cards = data
          .map<HospitalCardModel>((json) => HospitalCardModel.fromJson(json))
          .toList();

      setState(() {
        hospitalCards = cards;
        // filteredCards = cards; // if filtering is applied later
        isLoading = false; // hide loading
      });
    } catch (e) {
      setState(() {
        isLoading = false; // hide loading even on error
      });
      print("Error fetching hospital cards: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCards = hospitalCards.where((card) {
      final subServiceName = card.subServiceName.toString().toLowerCase() ?? '';
      final hospitalName = card.hospitalName.toString().toLowerCase() ?? '';
      final recommendedRaw = card.recommanded;
      final recommended = ['true', 'yes', '1', true].contains(recommendedRaw);

      final matchesSearch = subServiceName.contains(searchText.toLowerCase()) ||
          hospitalName.contains(searchText.toLowerCase());

      final shouldShow = showRecommendedOnly ? recommended : true;

      print('=========================');
      print('Hospital: $hospitalName');
      print('RecommendedRaw: ${card.price} ');
      print('Parsed Recommended: $recommended');
      print('Search Match: $matchesSearch');
      print('Show Recommended Only: $showRecommendedOnly');
      print('Included in List: ${matchesSearch && shouldShow}');
      print('=========================');

      return matchesSearch && shouldShow;
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
                  print("Recommended Filter Toggled: $showRecommendedOnly");
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
                      ? Center(
                          child: Text("No Doctors found for this subservice."))
                      : ListView.builder(
                          itemCount: filteredCards.length,
                          itemBuilder: (context, index) {
                            final card = filteredCards[index];
                            // String rawValue =
                            //     card.price; // e.g., "₹6132.240000000001"
                            //   parsedValue =
                            //      rawValue
                            return GestureDetector(
                              onTap: () {
                                if (widget.selectedService != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ServiceDetailsPage(
                                          mobileNumber: widget.mobileNumber,
                                          username: widget.username,
                                          selectedService: widget
                                              .selectedService!.subServiceId,
                                          hospitalName: card.hospitalName,
                                          hospitalId: card.hospitalId),
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
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.memory(
                                            base64Decode(card.hospitalLogo),
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
                                                Text(card.hospitalName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 4),
                                                Text("Sub Service: " +
                                                    card.subServiceName),
                                                Text("Service: " +
                                                    card.serviceName),
                                                SizedBox(height: 8),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.star,
                                                  size: 20,
                                                  color: Colors.amber),
                                              Text(
                                                  "${card.hospitalOverallRating.toStringAsFixed(1)}/5 "),
                                              // Text("4.5/5 "),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "₹${card.price.toStringAsFixed(0)} ",
                                                      // "₹900 ", // price
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "(${card.discountPercentage.toStringAsFixed(0)}%) ",
                                                      // "(10%)", // discount percentage
                                                      style: TextStyle(
                                                        fontSize:
                                                            12, // smaller font
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.red,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                  "₹${card.discountedCost.toStringAsFixed(0)} ",
                                                  // "₹1000",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.teal)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              final Uri url =
                                                  Uri.parse("${card.website}");
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url,
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              } else {
                                                throw "Could not launch $url";
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.language,
                                                    color: mainColor,
                                                    size:
                                                        20), // 🌐 website icon
                                                SizedBox(width: 6),
                                                Text(
                                                  "Website",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: mainColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              final Uri url = Uri.parse(
                                                  "${card.walkthrough}");
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url,
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              } else {
                                                throw "Could not launch $url";
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    "assets/clinic_tour.png",
                                                    height: 20,
                                                    width: 20,
                                                    color: mainColor),
                                                SizedBox(width: 6),
                                                Text("Virtual Clinic Tour",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: mainColor)),
                                              ],
                                            ),
                                          ),
                                          // Text(
                                          //     "${card['discountedCost'] ?? "NA"}"),
                                        ],
                                      )
                                    ],
                                  ),
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
