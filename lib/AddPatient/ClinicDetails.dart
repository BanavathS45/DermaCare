import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For time parsing

class ClinicSelectionPage {
  final clinics = [
    {
      "name": "Jubilee Hills Clinic",
      "address": "Road no.55 of Jubilee Hills, Hyderabad, Telangana",
      "KM": "5",
      "rating": "5/5",
      "timings": "09:00AM - 08:00PM"
    },
    {
      "name": "HITEC City Clinic",
      "address":
          "Hitech City Rd, Patrika Nagar, HITEC City, Hyderabad, Telangana 500081",
      "KM": "10",
      "rating": "3.5/5",
      "timings": "11:00AM - 07:00PM"
    },
    {
      "name": "Nagole Clinic",
      "address":
          "HNO 2-4-1065/3/B, Nagole Rd, near bridge, Samathapuri, Nagole, Hyderabad, Telangana 500102",
      "KM": "15",
      "rating": "4.5/5",
      "timings": "09:00AM - 11:00AM"
    },
  ];

  void showClinicBottomSheet(
      BuildContext context, Function(String) onClinicSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Clinic",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.teal[50],
                    child: Text(
                      "${clinics.length}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: clinics.length,
                  itemBuilder: (context, index) {
                    final clinic = clinics[index];

                    // Extract closing time and compare with current time
                    String timings = clinic['timings']!;
                    List<String> timeParts = timings.split(" - ");
                    DateTime now = DateTime.now();
                    DateTime closingTime = _parseTime(timeParts[1]);

                    bool isClosed = now.isAfter(closingTime);

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: isClosed
                            ? null
                            : () {
                                onClinicSelected(clinic['name']!);
                                Navigator.pop(context);
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Clinic Name
                              Text(
                                clinic['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isClosed ? Colors.grey : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),

                              // Address
                              Text(
                                clinic['address']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Details Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Distance
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.teal,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "${clinic['KM']} KM",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Rating
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        clinic['rating']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Timings
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: isClosed ? Colors.red : Colors.blue,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    clinic['timings']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isClosed ? Colors.red : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),

                              if (isClosed)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "Clinic is closed now",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
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
        );
      },
    );
  }

  /// Converts "06:00PM" to DateTime
  DateTime _parseTime(String timeStr) {
    final now = DateTime.now();
    final parsedTime = DateFormat("hh:mma").parse(timeStr);
    return DateTime(
        now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  }
}
