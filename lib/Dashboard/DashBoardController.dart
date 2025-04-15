import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cutomer_app/Modals/ServiceModal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../APIs/BaseUrl.dart';
import '../APIs/FetchServices.dart';
import '../BottomNavigation/Appoinments/AppointmentService.dart';
import '../BottomNavigation/Appoinments/BookingModal.dart';
import '../Services/CarouselSliderService.dart';
import '../Services/serviceb.dart';

class Dashboardcontroller extends GetxController {
  final AppointmentService _appointmentService = AppointmentService();
  final ImagePicker _picker = ImagePicker();
  final CarouselSliderService carouselSliderService = CarouselSliderService();

  final Rx<File?> imageFile = Rx<File?>(null);
  final RxBool isLoading = true.obs;
  final RxList<Serviceb> services = <Serviceb>[].obs;
  final RxList<AppointmentData> allAppointments = <AppointmentData>[].obs;
  final RxList<String> carouselImages = <String>[].obs;
  final selectedService = Rxn<Serviceb>();

  var selectedSubService = Rxn<Service>();
  var serviceList = <Serviceb>[];

  var subServiceList = <Service>[].obs;

  String statusMessage = "";

  void fetchSubServices(String categoryId) async {
    print("categoryId ${categoryId}");
    final result = await ServiceFetcher().fetchServices(categoryId);
    subServiceList.assignAll(result);
    print("subServiceList ${subServiceList}");
  }

  /// Store user session data
  void storeUserData(String mobileNumber, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('mobileNumber', mobileNumber);
    prefs.setString('username', username);
  }

  /// Load saved profile image
  Future<void> loadSavedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('profile_image');
    if (savedImagePath != null && File(savedImagePath).existsSync()) {
      imageFile.value = File(savedImagePath);
    }
  }

  /// Pick new image and store in SharedPreferences
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profile_image', file.path);
      imageFile.value = file;
    }
  }

  /// Show modal to pick image from gallery or camera
  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Fetch user appointments
  Future<void> fetchAppointments(String mobileNumber) async {
    final appointments =
        await _appointmentService.fetchAppointments(mobileNumber);

    allAppointments.assignAll(
      appointments.where((appointment) {
        return appointment.servicesAdded
            .any((service) => service.status.toLowerCase() == 'in_progress');
      }).toList(),
    );

    isLoading.value = false;
  }

  /// Fetch images for carousel
  Future<void> fetchImages() async {
    try {
      final images = await carouselSliderService.fetchImages();
      carouselImages.assignAll(images);
      print("imagesimages lengrt ${images.length}");
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  /// Fetch services/categories
  Future<void> fetchUserServices() async {
    try {
      print("Starting API call to fetch services...");
      isLoading.value = true;
      statusMessage = 'Fetching services...';

      final response = await http
          .get(Uri.parse(categoryUrl))
          .timeout(const Duration(seconds: 20), onTimeout: () {
        isLoading.value = false;
        statusMessage =
            'Your network seems to be down! \n Please check your internet connection.';
        print("Error: Network timeout.");
        throw TimeoutException('Network timeout');
      });

      print("response.statusCoderesponse.statusCode ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['data'] != null && responseBody['data'] is List) {
          final List<dynamic> serviceList = responseBody['data'];

          services.assignAll(serviceList.map((serviceData) {
            return Serviceb.fromJson({
              'categoryId': serviceData['categoryId'] ?? '',
              'categoryName': serviceData['categoryName'] ?? '',
              'categoryImage': serviceData['categoryImage'] ?? '',
            });
          }).toList());

          statusMessage = 'Services fetched successfully!';
        } else {
          statusMessage = 'Invalid data format received.';
        }
      } else {
        statusMessage =
            'Failed to fetch services. Status code: ${response.statusCode}';
      }
    } catch (e) {
      statusMessage = e is TimeoutException
          ? 'Your network seems to be down! \n Please check your internet connection.'
          : 'An error occurred while fetching services.';
      print("Error fetching services: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull to refresh
  Future<void> onRefresh(String mobileNumber) async {
    await fetchUserServices();
    await fetchAppointments(mobileNumber);
    await fetchImages();
  }
}
