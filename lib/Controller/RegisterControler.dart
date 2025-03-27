// import 'package:get/get.dart';
// import '../Modals/RegisterModel.dart';
//  // Import your RegisterModel

// class RegisterController extends GetxController {
//   var registerModel = RegisterModel().obs; // Observable RegisterModel
//   var isLoading = false.obs; // To track loading state
//   var errorMessage = ''.obs; // To track error messages

//   // Method to update the register model
//   void updateRegisterModel(String gender, String bloodGroup, int age, String emailId) {
//     registerModel.update((model) {
//       model!.gender = gender;
//       model.bloodGroup = bloodGroup;
//       model.age = age;
//       model.emailId = emailId;
     
//     });
//   }

//   // Simulate an API call for registration
//   Future<void> register() async {
//     isLoading.value = true; // Set loading state

//     // Simulate a delay for API call
//     await Future.delayed(Duration(seconds: 2));

//     // Here you would typically call your API and handle success/failure
//     // For now, we'll just simulate success
//     isLoading.value = false;
//     errorMessage.value = ''; // Clear any previous error messages
//   }
// }
