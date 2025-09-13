import 'dart:convert';
import 'package:cutomer_app/Controller/CustomerController.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/DoctorController.dart';
import 'package:cutomer_app/Doctors/Schedules/Schedule.dart';
import 'package:cutomer_app/Modals/ServiceModal.dart';
import 'package:cutomer_app/Services/SubServiceServices.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Widget/DoctorCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  final String symptoms;

  const ConsultationPrice({
    super.key,
    required this.mobileNumber,
    required this.username,
    required this.consulationType,
    required this.symptoms,
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
  bool isChecked = false;
  List<HospitalDoctorModel> hospitalDoctors = [];
  bool isLoading = false;
  bool isfLoading = false;
  @override
  @override
  void initState() {
    super.initState();
    setState(() => isfLoading = true); // start loading

    fetchHospitalDoctor().then((value) {
      setState(() {
        hospitalDoctors = value;
        isfLoading = false; // stop loading
        print("hospitalDoctors length ${hospitalDoctors.length}");
      });
    }).catchError((e) {
      setState(() => isfLoading = false);
      print("❌ Error: $e");
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

      final isRecommended = !showRecommendedOnly ||
          (item.hospital.recommended == true ||
              item.hospital.recommended?.toString().toLowerCase() == "true");

      print("dshfjhfdshj ${isRecommended}");
      print("dshfjhfdshj ${item.hospital.recommended}");

      final matchesGender = selectedGender == "All" ||
          item.doctor.gender.toLowerCase() == selectedGender.toLowerCase();

      final matchesRating = item.doctor.doctorAverageRating != null &&
          item.doctor.doctorAverageRating >= selectedRating;

      return matchesSearch && isRecommended && matchesGender && matchesRating;
    }).toList();
    // 🟡 If checkbox is checked, show only one doctor (e.g., the first one)

    final resultData = isChecked
        ? (filteredData.isNotEmpty ? [filteredData.first] : [])
        : filteredData;

    return Scaffold(
      appBar: CommonHeader(title: "Hospitals & Doctors"),
      backgroundColor: Colors.grey[100],
      body: Stack(children: [
        Padding(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Your main content
                  Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) async {
                              // Only trigger loading if user is checking the box (true)
                              if (value == true) {
                                setState(() {
                                  isChecked = true;
                                  isLoading = true;
                                });

                                await Future.delayed(Duration(seconds: 2));

                                setState(() {
                                  isLoading = false;
                                });

                                // Optional: show your filtered result here
                              } else {
                                // If unchecked, just update the state without loading
                                setState(() {
                                  isChecked = false;
                                });
                              }
                            },
                          ),
                          SizedBox(width: 2),
                          Text("Any Doctor"),
                        ],
                      ),
                    ],
                  ),

                  // Show your doctor list or content here
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Expanded(
                child: isfLoading
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SpinKitFadingCircle(
                              color: mainColor,
                              size: 40.0,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Loading doctors...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                    : hospitalDoctors.isEmpty
                        ? const Center(child: Text("No results found."))
                        : ListView.builder(
                            itemCount: resultData.length,
                            itemBuilder: (context, index) {
                              final item = resultData[index];
                              final hospital = item.hospital;
                              final doctor = item.doctor;

                              print("jshfskdhfdj ${filteredData.length}");
                              final isVideo =
                                  widget.consulationType.toLowerCase() ==
                                          "video consultation" ||
                                      widget.consulationType.toLowerCase() ==
                                          "online consultation";
                              print(
                                  "widget.consulationType ${widget.consulationType}");
                              print(
                                  "widget.consulationType  isVideo${isVideo}");
                              final cost = isVideo
                                  ? doctor.doctorFees.vedioConsultationFee
                                  : doctor.doctorFees.inClinicFee;

                              return InkWell(
                                onTap: () {
                                  print(item.doctor.doctorAvailabilityStatus);
                                  if (item.doctor.doctorAvailabilityStatus ==
                                      true) {
                                    Get.to(() => ScheduleScreen(
                                          doctorData: item,
                                          mobileNumber: widget.mobileNumber,
                                          username: widget.username,
                                        ));

                                    // loadSubService(item.hospital.hospitalId);
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
                                        item.doctor.doctorAvailabilityStatus ==
                                                true
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ✅ Clinic Name on Top
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: hospital
                                                    .name, // main hospital name
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: mainColor,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " (${(hospital.branch != null && hospital.branch!.isNotEmpty) ? hospital.branch : hospital.city})",
                                                style: TextStyle(
                                                  fontSize: 14, // smaller
                                                  fontWeight: FontWeight.w400,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // ✅ Doctor Row (Image Left, Details Right)
                                      SizedBox(
                                        height: 110, // Control card height
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            // Doctor Image (takes ~30%)
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: doctor.doctorPicture !=
                                                              null &&
                                                          doctor.doctorPicture
                                                              .isNotEmpty
                                                      ? Image.memory(
                                                          base64Decode(
                                                              cleanBase64(doctor
                                                                  .doctorPicture)),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          "https://via.placeholder.com/150",
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),

                                            // Doctor Details (takes remaining space)
                                            Flexible(
                                              flex: 7,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          doctor.doctorName,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Text(
                                                          doctor.qualification,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                        Text(
                                                          "${doctor.experience} Years Experience",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          widget
                                                              .consulationType,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          "₹${cost ?? 'N/A'}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "👨‍⚕️ ${doctor.doctorAverageRating.toStringAsFixed(1)}/5",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                        SizedBox(width: 20),
                                                        Text(
                                                          "🏥 ${hospital.hospitalOverallRating}/5",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
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
        // Fullscreen loader overlay
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "We are finding the best doctor for you,\nplease wait...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ]),
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
