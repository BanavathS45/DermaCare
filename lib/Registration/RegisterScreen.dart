import 'package:cutomer_app/Utils/Constant.dart';
import 'package:cutomer_app/Utils/capitalizeFirstLetter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loader_overlay/loader_overlay.dart';
import '../Inputs/CustomInputField.dart';
import '../Loading/FullScreeenLoader.dart';

import 'RegisterController.dart';
import '../Utils/CopyRigths.dart';
import '../Utils/DateInputFormat.dart';
import '../Utils/ElevatedButtonGredint.dart';

class RegisterScreen extends StatefulWidget {
  final String fullName;
  final String mobileNumber;
  const RegisterScreen({
    super.key,
    required this.fullName,
    required this.mobileNumber,
  });

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Registercontroller registercontroller = Registercontroller();
  void initState() {
    super.initState();
    // Split fullName by spaces, capitalize each word, then join them back together
    if (widget.fullName != null && widget.fullName.isNotEmpty) {
      registercontroller.nameController.text =
          capitalizeFirstLetter(widget.fullName);
    } else {
      registercontroller.nameController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: LoaderOverlay(
        overlayColor: const Color.fromARGB(149, 36, 35, 35),
        useDefaultLoading: false, // Disable default loader
        overlayWidgetBuilder: (context) => const FullscreenLoader(
          message: "Your data is being sent securely.\nPlease wait...",
          logoPath: 'assets/surecare_launcher.png',
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0.0, // Start from the top
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Image.asset(
                      'assets/surecare_launcher.png', // Ensure this path is correct
                      width: 150,

                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 40.0),
                    const Align(
                      alignment: Alignment(-1.0, 0.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Basic Details',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.all(
                          16.0), // Adjust the padding value as needed
                      child: Form(
                        key: registercontroller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: registercontroller.nameController,
                              labelText: 'Full Name',
                              enabled: false,
                            ),
                            const SizedBox(height: 10.0),
                            CustomTextField(
                              controller: registercontroller.emailController,
                              labelText: 'Enter Email ID',
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  registercontroller.validateEmail(value),
                            ),
                            const SizedBox(height: 10.0),
                            CustomTextField(
                              controller:
                                  registercontroller.dateOfBirthController,
                              labelText: 'Date of Birth',
                              keyboardType: TextInputType.number,
                              hintText: "DD/MM/YYYY",
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                                DateInputFormatter(), // 👈 your custom formatter
                              ],
                              validator: (value) =>
                                  registercontroller.validateDOB(value),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Gender',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: registercontroller.genderOptions
                                        .map((gender) {
                                      final bool isSelected =
                                          registercontroller.selectedGender ==
                                              gender;
                                      return Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              registercontroller
                                                  .selectedGender = gender;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? mainColor
                                                  : Colors.white,
                                              border: Border.all(
                                                color: isSelected
                                                    ? mainColor
                                                    : Colors.grey.shade400,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                gender,
                                                style: TextStyle(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.black87,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GradientButton(
                                text: "SUBMIT",
                                onPressed: () => registercontroller.submitForm(
                                    context,
                                    widget.fullName,
                                    widget.mobileNumber),
                              ),
                            ),
                            if (registercontroller.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  registercontroller.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            const SizedBox(height: 30.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          BottomAppBar(color: Colors.white, child: Copyrights()),
    );
  }
}
