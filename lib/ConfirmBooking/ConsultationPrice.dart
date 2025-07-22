import 'dart:convert';
import 'package:cutomer_app/Controller/CustomerController.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorController.dart';
import 'package:cutomer_app/Doctors/Schedules/Schedule.dart';
import 'package:cutomer_app/Modals/ServiceModal.dart';
import 'package:cutomer_app/Services/SubServiceServices.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Widget/DoctorCard.dart';
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
  bool sortByAZ = false;
  String selectedGender = "All"; // "Male", "Female", "All"
  double selectedRating = 0.0; // 4.5 if filtered

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

  SubService? subServiceDetails;
  void loadSubService(hospitalId) async {
    print("calling....");
    final result =
        await fetchSubServiceDetails(hospitalId, widget.subserviceid);
    setState(() {
      subServiceDetails = result;
      final selectedServicesController = Get.find<SelectedServicesController>();
      selectedServicesController
          .updateSelectedSubServices([subServiceDetails!]);
    });
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

      final matchesGender = selectedGender == "All" ||
          item.doctor.gender.toLowerCase() == selectedGender.toLowerCase();

      final matchesRating = item.doctor.doctorAverageRating != null &&
          item.doctor.doctorAverageRating >= selectedRating;

      return matchesSearch && isRecommended && matchesGender && matchesRating;
    }).toList();

    return Scaffold(
      appBar: CommonHeader(title: "Hospitals & Doctors"),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            buildFilters(),
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
                        final isVideo = widget.consulationType.toLowerCase() ==
                                "video consultation" ||
                            widget.consulationType.toLowerCase() ==
                                "online consultation";
                        print(
                            "widget.consulationType ${widget.consulationType}");
                        print("widget.consulationType  isVideo${isVideo}");
                        final cost = isVideo
                            ? doctor.doctorFees.vedioConsultationFee
                            : doctor.doctorFees.inClinicFee;

                        return InkWell(
                          onTap: () {
                            print(item.doctor.doctorAvailabilityStatus);
                            if (item.doctor.doctorAvailabilityStatus == true) {
                              Get.to(() => ScheduleScreen(
                                    doctorData: item,
                                    mobileNumber: widget.mobileNumber,
                                  ));

                              loadSubService(item.hospital.hospitalId);
                            } else {
                              // Optional: Show a snackbar or dialog to inform user
                              Get.snackbar(
                                'Unavailable',
                                'Doctor is not available at the moment.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  item.doctor.doctorAvailabilityStatus == true
                                      ? Colors.white
                                      : Colors.grey[300],
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
                                Column(
                                  children: [
                                    Text(
                                      "${item.doctor.doctorAvailabilityStatus == true ? "" : "Not Available"}",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
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
                                  ],
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
                                          "${doctor.doctorName}",
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

                                            Text(
                                              "${doctor.doctorAverageRating.toStringAsFixed(1)}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            )
                                            // Text("4.0") //TODO :do dynamically
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

  Widget buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 15,
        runSpacing: 10,
        children: [
          FilterChip(
            label: Text("A-Z",
                style: TextStyle(color: sortByAZ ? Colors.white : mainColor)),
            selectedColor: mainColor,
            selected: sortByAZ,
            showCheckmark: false,
            side: BorderSide(color: mainColor),
            onSelected: (val) => setState(() => sortByAZ = val),
          ),
          FilterChip(
            label: Icon(Icons.male,
                color: selectedGender == "Male" ? Colors.white : mainColor),
            selectedColor: mainColor,
            selected: selectedGender == "Male",
            showCheckmark: false,
            side: BorderSide(color: mainColor),
            onSelected: (val) =>
                setState(() => selectedGender = val ? "Male" : "All"),
          ),
          FilterChip(
            label: Icon(Icons.female,
                color: selectedGender == "Female" ? Colors.white : mainColor),
            selectedColor: mainColor,
            selected: selectedGender == "Female",
            showCheckmark: false,
            side: BorderSide(color: mainColor),
            onSelected: (val) =>
                setState(() => selectedGender = val ? "Female" : "All"),
          ),
          FilterChip(
            label: Icon(Icons.star,
                color: selectedRating >= 4.5 ? Colors.white : mainColor),
            selectedColor: mainColor,
            selected: selectedRating >= 4.5,
            showCheckmark: false,
            side: BorderSide(color: mainColor),
            onSelected: (val) =>
                setState(() => selectedRating = val ? 4.5 : 0.0),
          ),
        ],
      ),
    );
  }
}
