import 'package:cutomer_app/BottomNavigation/Appoinments/BookingModal.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../BottomNavigation/Appoinments/AppointmentView.dart';
import 'DateConverter.dart';
import 'InvoiceDownload.dart';

Widget buildAppointmentCard(AppointmentData appointment, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentPreview(
              appointment: appointment,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.patientName != ''
                              ? capitalizeFirstLetter(appointment.patientName)
                              : appointment.categoryName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${appointment.age}Y / ${appointment.gender}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          appointment.servicesAdded.isNotEmpty &&
                                  appointment.servicesAdded.first.status
                                          .toLowerCase() ==
                                      'accepted'
                              ? 'CONFIRMED'
                              : appointment.servicesAdded.isNotEmpty
                                  ? appointment.servicesAdded.first.status
                                      .toUpperCase()
                                  : 'UNKNOWN', // Handle empty servicesAdded array
                          style: TextStyle(
                            fontSize: 14,
                            color: appointment.servicesAdded.isNotEmpty &&
                                    appointment.servicesAdded.first.status
                                            .toLowerCase() ==
                                        'pending'
                                ? Colors.amber
                                : appointment.servicesAdded.isNotEmpty &&
                                        appointment.servicesAdded.first.status
                                                .toLowerCase() ==
                                            'completed'
                                    ? Colors.green
                                    : appointment.servicesAdded.isNotEmpty &&
                                            appointment
                                                    .servicesAdded.first.status
                                                    .toLowerCase() ==
                                                'accepted'
                                        ? Colors
                                            .blue // Custom color for 'accepted'
                                        : const Color.fromARGB(
                                            255, 0, 187, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (appointment.servicesAdded.isNotEmpty &&
                            (appointment.servicesAdded.first.status
                                        .toLowerCase() ==
                                    'accepted' ||
                                appointment.servicesAdded.first.status
                                        .toLowerCase() ==
                                    'in_progress') &&
                            (appointment.servicesAdded.first.startPin != null ||
                                appointment.servicesAdded.first.startPin !=
                                    null))
                          Row(
                            children: [
                              // const Icon(
                              //   Icons
                              //       .info, // Replace with your preferred indicator icon
                              //   color: Color.fromARGB(255, 0, 32, 26),
                              //   size: 16,
                              // ),
                              const SizedBox(width: 5),
                              Wrap(
                                spacing: 4, // Space between boxes
                                children: (appointment
                                            .servicesAdded.isNotEmpty &&
                                        appointment
                                                .servicesAdded.first.startPin !=
                                            null &&
                                        appointment
                                                .servicesAdded.first.endPin ==
                                            null)
                                    ? appointment.servicesAdded.first.startPin!
                                        .split(
                                            '') // Split each character into a list
                                        .map((digit) => Container(
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255,
                                                    255,
                                                    255,
                                                    255), // Box background color
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5), // Rounded corners
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255,
                                                      167,
                                                      159,
                                                      159), // Border color
                                                  width: 1, // Border width
                                                ),
                                              ),
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8,
                                                  vertical:
                                                      4), // Padding for each box
                                              child: Text(
                                                digit,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(255, 3,
                                                      122, 39), // Text color
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ))
                                        .toList()
                                    : (appointment.servicesAdded.isNotEmpty &&
                                            appointment.servicesAdded.first
                                                    .startPin !=
                                                null &&
                                            appointment.servicesAdded.first
                                                    .endPin !=
                                                null)
                                        ? appointment
                                            .servicesAdded.first.endPin!
                                            .split('')
                                            .map((digit) => Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color: const Color
                                                          .fromARGB(
                                                          255,
                                                          167,
                                                          159,
                                                          159), // Border color
                                                      width: 1, // Border width
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  child: Text(
                                                    digit,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 212, 3, 3),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ))
                                            .toList()
                                        : [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 220, 245, 240),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 170, 179, 177),
                                                  width: 1,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              child: const Text(
                                                " ",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 0, 32, 26),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF4A90E2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Service Type\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold, // Bold for "Service Type"
                              fontSize: 16, // Adjust font size as needed
                            ),
                          ),
                          const TextSpan(
                            text: '\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold, // Bold for "Service Type"
                              fontSize: 4, // Adjust font size as needed
                            ),
                          ),
                          TextSpan(
                            // text: '${appointment.patientName}',
                            text: appointment.servicesAdded.first.serviceName,
                            style: const TextStyle(
                              color: Color.fromARGB(210, 255, 255,
                                  255), // Different color for service name
                              fontWeight: FontWeight
                                  .normal, // Normal weight for service name
                              fontSize: 16, // Adjust font size for consistency
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 40, // Adjust thickness as needed
                    width: 2, // Full width of the column
                    color: Colors.white, // Center line color
                  ),
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.center, // Center the text
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${appointment.servicesAdded.first.startTime} ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold, // Bold for "Service Type"
                                fontSize: 16, // Adjust font size as needed
                              ),
                            ),
                            const TextSpan(
                              text: '\n',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold, // Bold for newline
                                fontSize: 4, // Adjust font size as needed
                              ),
                            ),
                            TextSpan(
                              text: formatDate(
                                  appointment.servicesAdded.first.startDate),
                              style: const TextStyle(
                                color: Color.fromARGB(210, 255, 255,
                                    255), // Different color for service name
                                fontWeight: FontWeight
                                    .normal, // Normal weight for service name
                                fontSize:
                                    16, // Adjust font size for consistency
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
