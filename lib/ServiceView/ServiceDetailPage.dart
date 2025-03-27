import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cutomer_app/ServiceView/FetchViewService.dart';
import 'package:flutter/material.dart';
import '../APIs/BaseUrl.dart';
import '../Loading/SkeletonLoder.dart';
import '../Utils/ConvertMinToHours.dart';
import '../Utils/Header.dart';
import 'ServiceDetail.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage(
      {super.key,
      required this.categoryName,
      required this.categoryId,
      required this.serviceId,
      required this.serviceName});
  final String categoryName;
  final String categoryId;
  final String serviceId;
  final String serviceName;

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage>
    with SingleTickerProviderStateMixin {
  late ApiService apiService;
  bool isLoading = true;
  List<ServiceDetails> services = [];

  late AnimationController _animationController;
  late Animation<Color?> _skeletonColorAnimation;

  // Replace with your data model.

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    fetchServices();

    // Initialize animation for skeleton loading
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _skeletonColorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

// /67498187abae773a58922196
  Future<void> fetchServices() async {
    print(
        "Fetching services for category serviceView Page: ${widget.serviceId}");

    final url = '${getAllServiceUrl}/${widget.categoryId}';

    try {
      print("Sending request to URL: $url");
      final response = await http.get(Uri.parse(url));
      print("API response status code: ${response.statusCode}");
      print("API response body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        // Access the 'data' list
        if (decodedResponse['data'] is List) {
          final List<dynamic> data = decodedResponse['data'];
          print("Decoded data: $data");

          // Find the service with the matching ID
          final serviceId =
              widget.serviceId; // Pass the service ID to this widget
          final serviceJson = data.firstWhere(
            (item) => item['serviceId'] == serviceId,
            orElse: () => null, // Fallback if no match is found
          );

          if (serviceJson != null) {
            print("Service JSON: $serviceJson");

            // Decode the image
            Uint8List decodedImage;
            try {
              decodedImage = base64Decode(serviceJson['viewImage']);
            } catch (e) {
              print("Error decoding image: $e");
              decodedImage = Uint8List(0); // Fallback if image decoding fails
            }

            // Map the service to the ServiceDetails model
            setState(() {
              services = [
                ServiceDetails(
                  viewDescription: serviceJson['viewDescription'] as String,
                  viewImage: decodedImage,
                  includes: serviceJson['includes'] as String,
                  readyPeriod: serviceJson['readyPeriod'] as String,
                  preparation: serviceJson['preparation'] as String? ?? '',
                  minTime: serviceJson['minTime'] as String? ?? '',
                )
              ];
              isLoading = false;
              print("Services: $services");
            });
          } else {
            print('Error: Service with ID $serviceId not found');
            setState(() => isLoading = false);
          }
        } else {
          print('Error: "data" is not a list');
          setState(() => isLoading = false);
        }
      } else {
        print('Error: ${response.reasonPhrase}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Failed to fetch services: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: "Service & Treatment Details",
        onNotificationPressed: () {},
        onSettingPressed: () {},
      ),
      body: isLoading
          ? SkeletonLoaderView(animation: _skeletonColorAnimation)
          : services.isEmpty
              ? Center(child: Text('Service details not available '))
              : ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          service.viewImage.isNotEmpty
                              ? Image.memory(
                                  service.viewImage,
                                  height: 150, // 👈 set fixed height
                                  width:
                                      double.infinity, // Optional: full width
                                  fit: BoxFit
                                      .fill, // Optional: scale image to fit
                                )
                              : Container(
                                  height: 150, // 👈 match fallback height
                                  color: Colors.grey.shade200,
                                  child: const Center(child: Text("No Image")),
                                ),
                          const SizedBox(height: 16),
                          Text(
                            service.viewDescription,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Service Name:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.serviceName,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Service Duration:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatTime(int.parse(service.minTime)),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'What is PRP Therapy:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            service.includes,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'PRP contains growth factors that :',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            service.readyPeriod,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Procedure Steps :',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            service.preparation,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
