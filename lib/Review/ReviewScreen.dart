import 'package:cutomer_app/BottomNavigation/Appoinments/GetAppointmentModel.dart';
import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the rating bar package

import '../BottomNavigation/Appoinments/PostBooingModel.dart';
 
import '../Utils/ElevatedButtonGredint.dart';

class ReviewScreen extends StatefulWidget {
  final HospitalDoctorModel? doctorData;
  final Getappointmentmodel? doctorBookings;
  const ReviewScreen(
      {super.key, required this.doctorData, required this.doctorBookings});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _doctorRating = 0.0; // Rating value for doctor
  double _hospitalRating = 0.0; // Rating value for hospital
  TextEditingController _commentController =
      TextEditingController(); // Controller for comment

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonHeader(
          title: 'Doctor & Hospital Review',
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              _buildReviewerSection(),
              SizedBox(height: 20),
              Divider(
                thickness: 1,
                height: 40,
                color: mainColor,
              ),
              SizedBox(height: 20),
              _buildHospitalRatingSection(),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: _buildSubmitButton(),
        ));
  }

  Widget _buildReviewerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'Rate Your Experience with the Doctor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage:
                    NetworkImage(widget.doctorData!.doctor.doctorPicture),
              ),
              SizedBox(height: 10),
              Text(
                widget.doctorData!.doctor.doctorName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                widget.doctorData!.doctor.specialization,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              _buildDoctorRatingSection(),
              SizedBox(height: 16),
            ],
          ),
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(8),
          child: TextField(
            controller: _commentController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Enter Your Comment Here...',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        RatingBar.builder(
          initialRating: _doctorRating,
          minRating: 1,
          itemSize: 40,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: index < _doctorRating ? mainColor : secondaryColor,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _doctorRating = rating;
            });
          },
        ),
      ],
    );
  }

  Widget _buildHospitalRatingSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'How Was Your Experience at the Hospital?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Center(
            child: RatingBar.builder(
              initialRating: _hospitalRating,
              minRating: 1,
              itemSize: 40,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: index < _hospitalRating ? secondaryColor : mainColor,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _hospitalRating = rating;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GradientButton(
      onPressed: () {
        // Handle the submission of the review here
        print('Doctor Rating: $_doctorRating');
        print('Hospital Rating: $_hospitalRating');
        print('Comment: ${_commentController.text}');
      },
      child: Text(
        "Add Review",
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
