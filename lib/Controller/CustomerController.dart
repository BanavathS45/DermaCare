import 'package:cutomer_app/Modals/AddressModal.dart';
import 'package:get/get.dart';
 

import '../Modals/ServiceModal.dart';
import '../Services/Service.dart';
import '../TreatmentAndServices/ServiceSelectionScreen.dart'; // Adjust the import based on your project structure

class SelectedServicesController extends GetxController {
  // Observable list of selected services
  var selectedServices = <Service>[].obs;
  RxString categoryId = "".obs;
  RxString categoryName = "".obs;

  // Method to update the selected services
  void updateSelectedServices(List<Service> services) {
    selectedServices.assignAll(services);
  }

  // Method to remove a service from the selected list
  void removeService(int index) {
    selectedServices.removeAt(index);
  }
}
 

class LocationController extends GetxController {
  var subLocality = ''.obs; // Observable to hold subLocality

  void setSubLocality(String subLoc) {
    subLocality.value = subLoc;
  }
}




 
// class SelectDateTimeController extends GetxController {
//   // Observables for data binding
//   var nameController = ''.obs;
//   var ageController = 0.obs;
//   var emailController = ''.obs;
//   var gender = "Unknown".obs;
//   var relation = ''.obs;
//   var saveAs = "Others".obs;
//   var mobileNumber = ''.obs;
//   var formattedAddress = ''.obs;
//   var username = ''.obs;
// var addressmodal = Rx<AddressModel?>(null);
//   // Function to set initial values
//   void setInitialValues({
//     required String patientname,
//     required int age,
//     required String email,
//     required String gender,
//     required String relation,
//     required String saveAs,
//     required String mobileNumber,
//     required String formattedAddress,
//     required String username,
//     required String addressmodal,
//   }) {
//     nameController.value = patientname;
//     ageController.value = age;
//     emailController.value = email;
//     this.gender.value = gender;
//     this.relation.value = relation;
//     this.saveAs.value = saveAs;
//     this.mobileNumber.value = mobileNumber;
//     this.formattedAddress.value = formattedAddress;
//     this.username.value = username;
//     this.addressmodal.value = addressmodal;
//   }
// }
 
 
