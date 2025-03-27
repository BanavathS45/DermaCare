import 'package:get/get.dart';

import '../ListOfDoctors/DoctorModel.dart';
import 'RatingAndFeedbackScreen.dart';

class Ratingcontroller {
   feedbackPage(HospitalDoctorModel doctor) {
    Get.to(Ratingandfeedbackscreen(doctor: doctor));
  }
}