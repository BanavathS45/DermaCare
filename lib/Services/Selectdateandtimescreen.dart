import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collection/collection.dart';
import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:cutomer_app/Services/CaluclationService.dart';
import 'package:cutomer_app/TreatmentAndServices/ServiceSelectionScreen.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Controller/CustomerController.dart';
import '../Help/Numbers.dart';
import '../Modals/CaluclationModel.dart';
import '../ServiceSumarry/ServiceIDDetails.dart';
import '../Utils/ScaffoldMessageSnacber.dart'; // For date formatting
// import 'package:http/http.dart' as http; // For making API calls

class SelectDateTimeScreen extends StatefulWidget {
  final String? formattedAddress;
  final String mobileNumber;
  final String? patientname;
  final int? age;
  final String? email;
  final String? username;
  final String? gender;
  final String? relation;
  final String? saveAs;
  final String? patientNumber;
  final String? bloodGroup;
  final AddressModel? addressmodal;
  final List? selectedServices;

  const SelectDateTimeScreen({
    Key? key,
    required this.formattedAddress,
    required this.mobileNumber,
    required this.username,
    this.selectedServices,
    this.patientname,
    this.age,
    this.email,
    this.gender,
    this.relation,
    this.saveAs,
    this.patientNumber,
    this.addressmodal,
    this.bloodGroup,
  }) : super(key: key);

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime? _startDate;

  int _noOfDays = 0;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _noOfHours = 1;
  String _timeDifference = '00:00 ';
  final _formKey = GlobalKey<FormState>();
  late List<Map<String, dynamic>>
      serviceNamesAndPrices; // Declare late, but initialize in initState
  final selectedServicesController = Get.find<SelectedServicesController>();
  // Formatter for displaying dates
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  final dateFormatters = DateFormat("dd-MM-yyyy");
  final timeFormatter24To12 =
      DateFormat("hh:mm a"); // 12-hour format with AM/PM
  final timeParser24 = DateFormat("HH:mm");
  late double subTotal;
  late double taxAmount;
  late double discount;
  late double discountedAmount;
  late double payAmount;
  bool proceeding = false;
  late String categoryId;
  late String categoryName;

  List<String>? eachServiceId;

  void _calculateDays(int serviceIndex) {
    if (selectedServicesData[serviceIndex].startDate != null &&
        selectedServicesData[serviceIndex].endDate != null) {
      DateTime startDate = selectedServicesData[serviceIndex].startDate!;
      DateTime endDate = selectedServicesData[serviceIndex].endDate!;

      // Check if endDate is before startDate
      if (endDate.isBefore(startDate)) {
        setState(() {
          selectedServicesData[serviceIndex].noOfDays =
              endDate.difference(startDate).inDays; // Negative number
        });
        print(
            "Error: End date is earlier than the start date. Days: ${selectedServicesData[serviceIndex].noOfDays}");
        return;
      }

      // Correct end date to include the full day
      DateTime correctedEndDate = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
        999,
      );

      setState(() {
        selectedServicesData[serviceIndex].noOfDays =
            correctedEndDate.difference(startDate).inDays + 1;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryId = selectedServicesController.categoryId.value;
    categoryName = selectedServicesController.categoryName.value;
    print(("widget***.addressmodal${widget.addressmodal}"));
    print(("widget***.formattedAddress${widget.formattedAddress}"));
    serviceNamesAndPrices = selectedServicesController.selectedServices
        .map((service) => {
              'serviceId': service.serviceId,
              'serviceName': service.serviceName,
              'pricing': service.pricing,
              'finalCost': service.finalCost,
              'discount': service.discount,
              'discountCost': service.discountCost,
              'discountedCost': service.discountedCost,
              'minTime': service.minTime,
              'tax': service.tax,
              'taxAmount': service.taxAmount,
            })
        .toList();
    // Initialize each service's data
    selectedServicesData = serviceNamesAndPrices.map((service) {
      return ServiceData(
        serviceName: service['serviceName'],
        noOfDays: 0, // Default value for number of days
        noOfHours: '00:00', // Default value for number of hours
      );
    }).toList();
    setState(() {
      proceeding = false;
    });
    // Print the array of objects as a JSON string
    print("Service details: ${jsonEncode(serviceNamesAndPrices)}");

    // Optionally, iterate and print each object in the array
    for (var service in serviceNamesAndPrices) {
      print("mfjdsjfdshfdsj $service");
    }

    print("formattedAddressdssdfdsf:${widget.formattedAddress}");
    eachServiceId =
        serviceNamesAndPrices.map((e) => e['serviceId'] as String).toList();

    // _calculateDays();
  }

  List<ServiceData> selectedServicesData = [];

  void _calculateTime() {
    if (_startTime != null && _endTime != null) {
      final startDateTime = _startTime!.toDateTime();
      final endDateTime = _endTime!.toDateTime();

      final difference = endDateTime.difference(startDateTime);

      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;

      setState(() {
        _timeDifference = "$hours hours ${minutes} minutes";
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  // Function to calculate the number of hours between two times
  void _calculateHours(int serviceIndex) {
    if (selectedServicesData[serviceIndex].startTime != null &&
        selectedServicesData[serviceIndex].endTime != null) {
      final start = selectedServicesData[serviceIndex].startTime!.hour * 60 +
          selectedServicesData[serviceIndex].startTime!.minute;
      final end = selectedServicesData[serviceIndex].endTime!.hour * 60 +
          selectedServicesData[serviceIndex].endTime!.minute;
      final differenceInMinutes = (end - start);

      setState(() {
        selectedServicesData[serviceIndex].noOfHours =
            '${differenceInMinutes ~/ 60} Hrs ${differenceInMinutes % 60} Mins';
      });
    }
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<List<CaluclationModel>> fetchAndUpdateCost(
      List<CaluclationModel> requestModels) async {
    print("🛠 Calling API with Request: ${jsonEncode({
          "servicesAdded": requestModels.map((e) => e.toJson()).toList()
        })}");

    try {
      Caluclationservice caluclationservice = Caluclationservice();

      // ✅ Call API
      Map<String, dynamic>? responseData =
          await caluclationservice.calculateAppointmentCost(requestModels);

      if (responseData?["statusCode"] == 200) {
        setState(() {
          proceeding = true;
        });
      }

      if (responseData != null &&
          responseData.containsKey("data") &&
          responseData["data"].containsKey("servicesAdded")) {
        print("✅ Final API Response: ${jsonEncode(responseData)}");

        // ✅ Convert JSON response to List<CaluclationModel>
        List<CaluclationModel> updatedList =
            (responseData["data"]["servicesAdded"] as List)
                .map((e) => CaluclationModel.fromJson(e))
                .toList();

        // ✅ Extract financial data
        subTotal = responseData["data"]["totalPrice"] ?? 0.0;

        taxAmount = responseData["data"]["totalTax"] ?? 0.0;
        discount = responseData["data"]["totalDiscountAmount"] ?? 0.0;
        discountedAmount = responseData["data"]["totalDiscountedAmount"] ?? 0.0;
        payAmount = responseData["data"]["payAmount"] ?? 0.0;
        print("subTotal subTotal ${subTotal}");
        return updatedList;
      }
      // Handle the case where responseData is missing required fields
      else {
        setState(() {
          proceeding = false;
        });
        print("❌ API returned null or invalid response.");
        return [];
      }
    } catch (e, stackTrace) {
      setState(() {
        proceeding = false;
      });
      print("❌ API Call Failed: $e");
      print("Stack Trace: $stackTrace");
      return [];
    }
  }

  String convertTimeOfDayTo12HourFormat(TimeOfDay? timeOfDay) {
    print(
        "Input TimeOfDay: ${timeOfDay?.hour}:${timeOfDay?.minute}"); // Debugging

    if (timeOfDay == null) return ""; // Handle null case
    try {
      // Create a DateTime using today's date and the TimeOfDay
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      // Debugging: Print the constructed DateTime
      print("Constructed DateTime: $dateTime");

      // Format the DateTime to 12-hour format with AM/PM
      return DateFormat('hh:mm a').format(dateTime); // Explicit 12-hour format
    } catch (e) {
      print("Error formatting TimeOfDay: $timeOfDay - $e");
      return ""; // Return empty string on error
    }
  }

  List<CaluclationModel> servicesAddedList = []; // Declare the list

  Future<void> _sendDataToBackend() async {
    setState(() {
      proceeding = true;
    });
    print("Clicked _sendDataToBackend");

    if (selectedServicesData != null && selectedServicesData.isNotEmpty) {
      print(
          "selectedServicesData: ${selectedServicesData.map((e) => e.toString()).toList()}");
    } else {
      print("No selected services found in selectedServicesData");
      return; // Exit early if no data is found
    }

    // Define date formatter
    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

    // Build servicesDataForBackend
    List<Map<String, dynamic>> servicesDataForBackend =
        selectedServicesData.map((serviceData) {
      return {
        'serviceName': serviceData.serviceName,
        'startDate': serviceData.startDate != null
            ? dateFormatter
                .format(serviceData.startDate!) // Format to dd-MM-yyyy
            : null,
        'endDate': serviceData.endDate != null
            ? dateFormatter.format(serviceData.endDate!) // Format to dd-MM-yyyy
            : null,
        'startTime': serviceData.startTime, // Keep as String
        'endTime': serviceData.endTime, // Keep as String
        'noOfDays': serviceData.noOfDays,
        'noOfHours': serviceData.noOfHours,
      };
    }).toList();

    print("servicesDataForBackend: $servicesDataForBackend");

    // Navigate to the next screen
    var servicesDataForBackendTime = servicesDataForBackend.map((service) {
      // Convert TimeOfDay to 12-hour format string

      return {
        'serviceName': service['serviceName'],
        'startDate': service['startDate'] != null
            ? dateFormatter.parse(service['startDate']) // Parse back
            : null,
        'endDate': service['endDate'] != null
            ? dateFormatter.parse(service['endDate']) // Parse back
            : null,
        'startTime': convertTimeOfDayTo12HourFormat(
            service['startTime']), // Keep as String
        'endTime': convertTimeOfDayTo12HourFormat(
          service['endTime'],
        ), // Keep as String
        'noOfDays': service['noOfDays'],
        'noOfHours': service['noOfHours'],
      };
    }).toList();

    // Ensure `servicesDataForBackendTime` has data
    if (servicesDataForBackendTime.isEmpty) {
      print("❌ servicesDataForBackendTime is empty. Skipping calculation.");
      return;
    } else {
      print(
          "✅ servicesDataForBackendTime contains data: $servicesDataForBackendTime");
    }

    try {
      // Ensure indices are valid before accessing data
      if (servicesDataForBackendTime.length != serviceNamesAndPrices.length) {
        print(
            "❌ Mismatch between servicesDataForBackendTime and serviceNamesAndPrices!");
        return;
      }

      servicesAddedList = serviceNamesAndPrices
          .mapIndexed((index, service) {
            final Map<String, dynamic>? serviceDateAndTime =
                index < servicesDataForBackendTime.length
                    ? servicesDataForBackendTime[index]
                    : null; // Prevent index error

            if (serviceDateAndTime == null) {
              print(
                  "❌ Skipping service at index $index due to missing time data.");
              return null; // Skip this entry
            }

            return CaluclationModel(
              serviceId: service['serviceId']?.toString() ?? '',
              serviceName: service['serviceName'] ?? '',
              price: (service['pricing'] ?? 0.0).toDouble(),
              discount: (service['discount'] ?? 0.0).toDouble(),
              discountAmount: (service['discountCost'] ?? 0.0).toDouble(),
              discountedCost: (service['discountedCost'] ?? 0.0).toDouble(),
              tax: (service['tax'] ?? 0.0).toDouble(),
              taxAmount: (service['taxAmount'] ?? 0.0).toDouble(),
              finalCost: (service['finalCost'] ?? 0.0).toDouble(),
              startDate: serviceDateAndTime['startDate'] is DateTime
                  ? DateFormat('dd-MM-yyyy')
                      .format(serviceDateAndTime['startDate'])
                  : '',
              endDate: serviceDateAndTime['endDate'] is DateTime
                  ? DateFormat('dd-MM-yyyy')
                      .format(serviceDateAndTime['endDate'])
                  : '',
              startTime: serviceDateAndTime['startTime'],
              endTime: serviceDateAndTime['endTime'],
              numberOfDays: serviceDateAndTime['noOfDays'] ?? 0,
              numberOfHours: serviceDateAndTime['noOfHours'] ?? "",
            );
          })
          .whereType<CaluclationModel>()
          .toList(); // Filter out null values

      print(
          "✅ servicesAddedList contains data: ${jsonEncode(servicesAddedList.map((e) => e.toJson()).toList())}");

      // ✅ Call API once with the full list instead of multiple calls
      List<CaluclationModel> response =
          await fetchAndUpdateCost(servicesAddedList);

      if (response != null) {
        print("✅ API Response: ${jsonEncode(response)}");
      } else {
        setState(() {
          proceeding = false;
        });
        print("❌ API returned null response.");
      }
    } catch (e, stackTrace) {
      setState(() {
        proceeding = false;
      });
      print("❌ Error before calling fetchAndUpdateCost: $e");
      print("Stack Trace: $stackTrace");
    }

    List<CaluclationModel> updatedCalculations =
        await fetchAndUpdateCost(servicesAddedList);

    if (updatedCalculations.isNotEmpty) {
      print(
          "✅ API Response: ${jsonEncode(updatedCalculations.map((e) => e.toJson()).toList())}");

      await Future.delayed(Duration(seconds: 1));

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Serviceiddetails(
                  addressModel: widget.addressmodal,
                  mobileNumber: widget.mobileNumber,
                  formattedAddress: widget.formattedAddress ?? '',
                  patientName: widget.patientname ?? '',
                  patientNumber: widget.patientNumber ?? '',
                  age: widget.age ?? 0,
                  email: widget.email ?? '',
                  username: widget.username ?? '',
                  gender: widget.gender ?? '',
                  relation: widget.relation ?? '',
                  saveAs: widget.saveAs ?? '',
                  selectedServices: widget.selectedServices ?? [],
                  address: widget.formattedAddress ?? '',
                  servicesDateAndTime: servicesDataForBackendTime,
                  serviceCaluclations: updatedCalculations,
                  subTotal: subTotal,
                  taxAmount: taxAmount,
                  discount: discount,
                  discountedAmount: discountedAmount,
                  payAmount: payAmount,
                )),
      );
      setState(() {
        proceeding = false;
      });
    }
    print("_noOfDays $servicesDataForBackend");
  }

  // Function to show the date picker
  _showDatePicker(bool isStartDate, int serviceIndex, int days) async {
    if (serviceIndex < 0 || serviceIndex >= selectedServicesData.length) {
      throw ArgumentError('Invalid serviceIndex: $serviceIndex');
    }

    DateTime initialDate = DateTime.now();
    DateTime firstDate = initialDate;
    DateTime lastDate = initialDate.add(Duration(days: days));

    final List<DateTime?>? pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDate: firstDate,
        lastDate: lastDate,
        calendarType: CalendarDatePicker2Type.single,
      ),
      dialogSize: const Size(325, 400),
      value: [
        isStartDate
            ? (selectedServicesData[serviceIndex].startDate ?? initialDate)
            : (selectedServicesData[serviceIndex].endDate ?? initialDate),
      ],
    );

    if (pickedDates == null || pickedDates.isEmpty || pickedDates[0] == null) {
      return; // No valid date selected
    }

    if (pickedDates != null &&
        pickedDates.isNotEmpty &&
        pickedDates[0] != null) {
      setState(() {
        if (isStartDate) {
          selectedServicesData[serviceIndex].startDate = pickedDates[0];
        } else {
          selectedServicesData[serviceIndex].endDate = pickedDates[0];
        }
        _calculateDays(serviceIndex);
      });
    }
  }

  TimeOfDay _snapToNearest30Minutes(TimeOfDay time) {
    // Convert time to total minutes
    int totalMinutes = time.hour * 60 + time.minute;

    // Find the remainder when dividing by 30
    int remainder = totalMinutes % 30;

    // Determine whether to round down or up
    if (remainder < 15) {
      totalMinutes -= remainder; // Round down
    } else {
      totalMinutes += (30 - remainder); // Round up
    }

    // Ensure hours stay within 24-hour format
    int hour = (totalMinutes ~/ 60) % 24; // Modulo to prevent overflow
    int minute = totalMinutes % 60;

    return TimeOfDay(hour: hour, minute: minute);
  }

// Function to format the snapped TimeOfDay to a readable string
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format =
        DateFormat.jm(); // This will format time to "8:30 AM" or "3:15 PM"
    return format.format(dateTime); // Returns formatted time as a string
  }

  String? _startDateValidator(String? value) {
    if (_startDate == null) {
      return 'Start date is required';
    }

    return null;
  }

  Duration? serviceDuration; // Example: Service duration of 90 minutes
  late int totalMinTime;

  _showTimePicker(bool isStartTime, int serviceIndex) async {
    if (!context.mounted) return; // Ensures the widget is still active

    // Get the current date and time
    DateTime now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    // Get the service start date
    DateTime? serviceStartDate = selectedServicesData[serviceIndex].startDate;

    // Set the initial time for the time picker
    TimeOfDay initialTime = isStartTime
        ? selectedServicesData[serviceIndex].startTime ?? currentTime
        : selectedServicesData[serviceIndex].endTime ?? currentTime;

    // Determine if the service date is today
    bool isToday = serviceStartDate != null &&
        serviceStartDate.year == now.year &&
        serviceStartDate.month == now.month &&
        serviceStartDate.day == now.day;

    // Show the time picker
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // Ensures visibility in dark mode
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      // Convert TimeOfDay to minutes for easy comparison
      int currentTimeInMinutes = currentTime.hour * 60 + currentTime.minute;
      int selectedTimeInMinutes = selectedTime.hour * 60 + selectedTime.minute;

      // Restrict past time selection **only if the selected date is today**
      if (isToday && selectedTimeInMinutes < currentTimeInMinutes) {
        ScaffoldMessageSnackbar.show(
          context: context,
          message: "Please select a valid future time for today.",
          type: SnackbarType.error,
          actionLabel: "OK",
          durationInSeconds: 5,
        );
        // showErrorToast(msg: 'Please select a valid future time for today.');
        return; // Exit the function to prevent invalid selection
      }

      TimeOfDay finalTime = selectedTime;

      // If selected time is within 30 minutes of the current time, add one hour
      if (isToday && (selectedTimeInMinutes - currentTimeInMinutes <= 30)) {
        DateTime newDateTime = DateTime(now.year, now.month, now.day,
                selectedTime.hour, selectedTime.minute)
            .add(Duration(hours: 1));

        finalTime =
            TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
      }

      // Snap the selected time to the nearest 30-minute interval
      TimeOfDay snappedTime = _snapToNearest30Minutes(finalTime);

      // Get the duration (minTime) for the specific service using serviceIndex
      String? minTimeString =
          serviceNamesAndPrices[serviceIndex]['minTime'] as String?;
      int minTime = int.tryParse(minTimeString ?? '') ?? 0;
      Duration serviceDuration = Duration(minutes: minTime);

      bool isConflict = _checkTimeConflict(snappedTime, serviceIndex);

      if (isConflict) {
        ScaffoldMessageSnackbar.show(
          context: context,
          message:
              "This time conflicts with another service. Please select a time with a 30 min - 1hr buffer. ",
          serviceName:
              ("${selectedServicesData[serviceIndex].serviceName} Details "),
          type: SnackbarType.warning,
          actionLabel: "OK",
          durationInSeconds: 5,
        );
        // showErrorToast(msg: '');
      } else {
        setState(() {
          if (isStartTime) {
            // Update startTime for the selected service
            selectedServicesData[serviceIndex].startTime = snappedTime;
            // Calculate and set the endTime based on service duration
            selectedServicesData[serviceIndex].endTime =
                _calculateEndTime(snappedTime, serviceDuration);
          } else {
            // Update endTime for the selected service
            selectedServicesData[serviceIndex].endTime = snappedTime;
          }

          // Recalculate hours or other properties if needed
          _calculateHours(serviceIndex);
        });
      }
    } else {
      // Show error if an invalid time is selected
      ScaffoldMessageSnackbar.show(
          context: context,
          message: "Please select a valid time",
          type: SnackbarType.warning,
          actionLabel: "OK",
          durationInSeconds: 5,
          subTitle: "cannot be in the past.");

      // showErrorToast(msg: 'Please select a valid time');
    }
  }

  bool _checkTimeConflict(TimeOfDay selectedTime, int serviceIndex) {
    Duration bufferTime = Duration(minutes: 30);

    for (int i = 0; i < selectedServicesData.length; i++) {
      if (i == serviceIndex) continue; // Skip the current service

      TimeOfDay? existingStartTime = selectedServicesData[i].startTime;
      TimeOfDay? existingEndTime = selectedServicesData[i].endTime;

      if (existingStartTime != null && existingEndTime != null) {
        // Convert times to minutes for comparison
        int selectedTimeInMinutes =
            selectedTime.hour * 60 + selectedTime.minute;
        int existingStartTimeInMinutes =
            existingStartTime.hour * 60 + existingStartTime.minute;
        int existingEndTimeInMinutes =
            existingEndTime.hour * 60 + existingEndTime.minute;

        // Check if there's an overlap or conflict within the 30-minute buffer time
        if ((selectedTimeInMinutes >=
                existingStartTimeInMinutes - bufferTime.inMinutes &&
            selectedTimeInMinutes <=
                existingEndTimeInMinutes + bufferTime.inMinutes)) {
          return true;
        }
      }
    }

    return false;
  }

// Function to calculate end time based on service duration (using start time)
  TimeOfDay _calculateEndTime(TimeOfDay startTime, Duration duration) {
    // Convert start time to minutes
    final startInMinutes = startTime.hour * 60 + startTime.minute;

    // Add the service duration (in minutes)
    final endInMinutes = startInMinutes + duration.inMinutes;

    // Calculate the end time's hour and minute
    final endHour = endInMinutes ~/ 60;
    final endMinute = endInMinutes % 60;

    // Return the calculated end time
    return TimeOfDay(hour: endHour, minute: endMinute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: 'Select Date And Time',
        onNotificationPressed: () {},
        onSettingPressed: () async {
          await whatsUpChat();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "⚠️ Note: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.redAccent),
                        ),
                        TextSpan(
                          text:
                              "The appointment should be booked within a week",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: serviceNamesAndPrices.asMap().entries.map((entry) {
                    final int serviceIndex = entry.key;
                    final service = entry.value;

                    return Card(
                      //TODO:Not showing in UI
                      color: Colors.white,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Service Title with Delete Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text occupying 80% width
                                Expanded(
                                  flex: 10, // 80% of the available space
                                  child: Text(
                                    '${service['serviceName']} Details'
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 3, // Restrict to two lines
                                    overflow: TextOverflow
                                        .ellipsis, // Show "..." if text overflows
                                  ),
                                ),

                                // Spacer for remaining 20%
                                Spacer(flex: 1),

                                // Floating Gradient Delete Button
                                if (serviceNamesAndPrices.length > 1)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          serviceNamesAndPrices
                                              .removeAt(serviceIndex);
                                          selectedServicesController
                                              .selectedServices
                                              .removeAt(serviceIndex);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Colors.teal, Colors.blue],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                              spreadRadius: 2,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        child: const CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.transparent,
                                          child: Icon(Icons.delete,
                                              color: Colors.white, size: 22),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Start Date Picker
                            TextFormField(
                              validator: (value) {
                                if (selectedServicesData[serviceIndex]
                                        .startDate ==
                                    null) {
                                  return 'Please select a start date';
                                }
                                return null;
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Service Start Date',
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    await _showDatePicker(
                                        true, serviceIndex, 7);
                                  },
                                ),
                              ),
                              controller: TextEditingController(
                                text: selectedServicesData[serviceIndex]
                                            .startDate !=
                                        null
                                    ? _dateFormat.format(
                                        selectedServicesData[serviceIndex]
                                            .startDate!)
                                    : '',
                              ),
                              onTap: () async {
                                await _showDatePicker(true, serviceIndex, 7);
                              },
                            ),

                            const SizedBox(height: 20),

                            // End Date Picker with Validation
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // End Date Field
                                TextFormField(
                                  validator: (value) {
                                    if (selectedServicesData[serviceIndex]
                                            .endDate ==
                                        null) {
                                      return 'Please select an end date';
                                    }

                                    int noOfDays =
                                        selectedServicesData[serviceIndex]
                                            .noOfDays;
                                    if (noOfDays <= 0) {
                                      return 'Please select an end date greater than \nthe start date';
                                    }
                                    return null; // Return null if validation passes

                                    return null;
                                  },
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Service End Date',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.calendar_today),
                                      onPressed: () async {
                                        if (selectedServicesData[serviceIndex]
                                                .startDate ==
                                            null) {
                                          setState(() {
                                            selectedServicesData[serviceIndex]
                                                .showStartDateError = true;
                                          });
                                        } else {
                                          setState(() {
                                            selectedServicesData[serviceIndex]
                                                .showStartDateError = false;
                                          });
                                          await _showDatePicker(
                                              false, serviceIndex, 30);
                                        }
                                      },
                                    ),
                                  ),
                                  controller: TextEditingController(
                                    text: selectedServicesData[serviceIndex]
                                                .endDate !=
                                            null
                                        ? _dateFormat.format(
                                            selectedServicesData[serviceIndex]
                                                .endDate!)
                                        : '',
                                  ),
                                  onTap: () async {
                                    if (selectedServicesData[serviceIndex]
                                            .startDate ==
                                        null) {
                                      setState(() {
                                        selectedServicesData[serviceIndex]
                                            .showStartDateError = true;
                                      });
                                    } else {
                                      setState(() {
                                        selectedServicesData[serviceIndex]
                                            .showStartDateError = false;
                                      });
                                      await _showDatePicker(
                                          false, serviceIndex, 30);
                                    }
                                  },
                                ),

                                if (selectedServicesData[serviceIndex]
                                        .showStartDateError ==
                                    true)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Please select a start date first.',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 20),

// Number of Days Field - Greyed Out After End Date Selection
                            TextFormField(
                              readOnly: true,
                              enabled:
                                  selectedServicesData[serviceIndex].endDate ==
                                      null, // Disable if end date is selected
                              decoration: InputDecoration(
                                labelText: 'No. of Days',
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              controller: TextEditingController(
                                text: selectedServicesData[serviceIndex]
                                            .numberOfDays !=
                                        null
                                    ? selectedServicesData[serviceIndex]
                                        .numberOfDays
                                        .toString()
                                    : '',
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Start Time and End Time
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Service Start Time',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.access_time),
                                        onPressed: () async {
                                          await _showTimePicker(
                                              true, serviceIndex);
                                        },
                                      ),
                                    ),
                                    controller: TextEditingController(
                                      text: selectedServicesData[serviceIndex]
                                                  .startTime !=
                                              null
                                          ? selectedServicesData[serviceIndex]
                                              .startTime!
                                              .format(context)
                                          : '',
                                    ),
                                    onTap: () async {
                                      await _showTimePicker(true, serviceIndex);
                                    },
                                    validator: (value) {
                                      if (selectedServicesData[serviceIndex]
                                              .startTime ==
                                          null) {
                                        return 'Please select a start time';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                const SizedBox(width: 16),

// End Time Field - Disable if Start Time is selected
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    enabled: selectedServicesData[serviceIndex]
                                            .startTime ==
                                        null, // Disable after start time is selected
                                    decoration: InputDecoration(
                                      labelText: 'Service End Time',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.access_time),
                                        onPressed: selectedServicesData[
                                                        serviceIndex]
                                                    .startTime ==
                                                null
                                            ? null // Disable button if start time is selected
                                            : () async {
                                                await _showTimePicker(
                                                    false, serviceIndex);
                                              },
                                      ),
                                    ),
                                    controller: TextEditingController(
                                      text: selectedServicesData[serviceIndex]
                                                  .endTime !=
                                              null
                                          ? selectedServicesData[serviceIndex]
                                              .endTime!
                                              .format(context)
                                          : '',
                                    ),
                                    onTap: selectedServicesData[serviceIndex]
                                                .startTime ==
                                            null
                                        ? null
                                        : () async {
                                            await _showTimePicker(
                                                false, serviceIndex);
                                          },
                                    validator: (value) {
                                      if (selectedServicesData[serviceIndex]
                                                  .startTime !=
                                              null &&
                                          selectedServicesData[serviceIndex]
                                                  .endTime ==
                                              null) {
                                        return 'Please select an end time';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),
                            const Text(
                              "⚠️ Service cannot be booked immediately. The time will be rounded to the nearest 30 min to 1 hr interval.",
                              style: TextStyle(color: Colors.teal),
                            ),

                            const SizedBox(height: 20),

                            // Number of Hours
                            TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Total no.of hours',
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              controller: TextEditingController(
                                text: selectedServicesData[serviceIndex]
                                    .noOfHours
                                    .toString(),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: Row(
              children: [
                /// "Add Service" button - 20% width
                Expanded(
                  flex: 35,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor:
                          Colors.teal, // Custom color for Add Service
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectServicesPage(
                            categoryName: categoryName,
                            categoryId: categoryId,
                            mobileNumber: widget.mobileNumber,
                            username: widget.username!,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Add Service",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ),

                /// 1% Gap
                const SizedBox(width: 8), // Adjust this for exact 1% spacing

                /// "Proceed" button - 79% width
                Expanded(
                  flex: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        DateTime now = DateTime.now();
                        bool isValid = true; // Track overall validation status

                        for (int serviceIndex = 0;
                            serviceIndex < serviceNamesAndPrices.length;
                            serviceIndex++) {
                          // Get selected date and time for the service
                          DateTime? selectedDate =
                              selectedServicesData[serviceIndex].startDate;
                          TimeOfDay? selectedTime =
                              selectedServicesData[serviceIndex].startTime;
                          String? serviceName =
                              selectedServicesData[serviceIndex].serviceName;

                          // Check if date and time are selected
                          if (selectedDate == null || selectedTime == null) {
                            ScaffoldMessageSnackbar.show(
                                context: context,
                                type: SnackbarType.error,
                                message:
                                    "Please select both date and time for all services.",
                                actionLabel: "OK",
                                durationInSeconds: 5,
                                subTitle: "cannot be in the past.");
                            // showErrorToast(
                            //     msg:
                            //         'Please select both date and time for all services.');
                            isValid = false;
                            break; // Stop checking further if validation fails
                          }

                          // Convert TimeOfDay to DateTime for comparison
                          DateTime selectedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          // Validation: Show error if selected date & time is in the past
                          if (selectedDateTime.isBefore(now)) {
                            ScaffoldMessageSnackbar.show(
                                context: context,
                                message: "Selected date and time for service ",
                                serviceName: ("${serviceName} Details "),
                                type: SnackbarType.error,
                                actionLabel: "OK",
                                durationInSeconds: 5,
                                subTitle: "cannot be in the past.");

                            isValid = false;
                            break; // Stop checking further if validation fails
                          }
                        }

                        if (isValid) {
                          _sendDataToBackend();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (proceeding) // Show loader only when proceeding
                          const SpinKitCircle(
                            color: Colors.white,
                            size: 16.0,
                          ),

                        if (proceeding)
                          const SizedBox(
                              width: 10), // Space between loader and text

                        Text(
                          proceeding ? 'PROCEEDING' : 'PROCEED',
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extension to convert TimeOfDay to DateTime for comparison
extension TimeOfDayConversion on TimeOfDay {
  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, this.hour, this.minute);
  }
}

class ServiceData {
  String serviceName;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int noOfDays;
  String noOfHours;
  bool showStartDateError = false;

  ServiceData({
    required this.serviceName,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    required this.noOfDays,
    required this.noOfHours,
  });
  int get numberOfDays => noOfDays;
}
