import 'dart:convert';
import 'package:cutomer_app/Doctors/Schedules/Schedule.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Doctors/ListOfDoctors/DoctorScreen.dart';
import '../Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import '../Services/GetHospiatlsAndDoctorWithSubService.dart';
import '../Utils/Header.dart';

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

  List<HospitalDoctorModel> hospitalDoctors = [];

  @override
  void initState() {
    super.initState();
    fetchHospitalDoctorBySubServiceId(widget.subserviceid).then((value) {
      setState(() {
        hospitalDoctors = value;
      });
    }).catchError((e) {
      print("Error: $e");
    });
  }

  String cleanBase64(String base64String) {
    if (base64String.contains(',')) {
      return base64String.split(',')[1];
    }
    return base64String;
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = hospitalDoctors.where((item) {
      final matchesSearch =
          item.hospital.name.toLowerCase().contains(searchText.toLowerCase()) ||
              item.doctor.doctorName
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
      final isRecommended =
          !showRecommendedOnly || (item.hospital.recommended ?? false);
      return matchesSearch && isRecommended;
    }).toList();

    return Scaffold(
      appBar: CommonHeader(title: "Hospitals & Doctors"),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search hospital or doctor",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) => setState(() => searchText = val),
            ),
            SizedBox(height: 12),
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
                        : "Recommended Only",
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
            Expanded(
              child: filteredData.isEmpty
                  ? Center(child: Text("No results found."))
                  : ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        final hospital = item.hospital;
                        final doctor = item.doctor;
                        final isVideo =
                            widget.consulationType.toLowerCase() == "video";
                        final cost = isVideo
                            ? doctor.doctorFees.vedioConsultationFee
                            : doctor.doctorFees.inClinicFee;

                        return InkWell(
                          onTap: () {
                            Get.to(() => ScheduleScreen(
                                  doctorData: item,
                                  mobileNumber: widget.mobileNumber,
                                ));
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => Doctorscreen(
                            //       mobileNumber: widget.mobileNumber,
                            //       username: widget.username,
                            //       subServiceID: widget.subserviceid,
                            //       hospiatlName: hospital.name,
                            //     ),
                            //   ),
                            // );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
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
                                  child: doctor.doctorPicture != null &&
                                          doctor.doctorPicture.isNotEmpty
                                      ? Image.memory(
                                          base64Decode(cleanBase64(
                                              doctor.doctorPicture)),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          "https://via.placeholder.com/100",
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
                                        Text(
                                          hospital.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal[800],
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "Dr. ${doctor.doctorName}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 4),
                                        Text("Service: ${widget.serviceName}"),
                                        Text(
                                            "Subservice: ${widget.subserviceName}"),
                                        SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              widget.consulationType,
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              "₹${cost ?? 'N/A'}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal[700],
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors.amber, size: 18),
                                            SizedBox(width: 4),
                                            // Text(
                                            //   doctor.averageRating
                                            //           ?.toStringAsFixed(1) ??
                                            //       "4.0",
                                            //   style: TextStyle(
                                            //       fontWeight: FontWeight.w500),
                                            // )
                                            Text("4.0") //TODO :do dynamically
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
