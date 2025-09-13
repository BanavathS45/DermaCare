import 'dart:convert';
import 'package:cutomer_app/Clinic/AboutClinicController.dart';
import 'package:cutomer_app/Utils/Header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicScreen extends StatelessWidget {
  final controller = Get.put(ClinicController());

  @override
  Widget build(BuildContext context) {
    controller.fetchClinic("H_2");

    return Scaffold(
      appBar: CommonHeader(title: "Clinic Details"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text("Error: ${controller.error}"));
        }

        final clinic = controller.clinic.value;
        if (clinic == null) {
          return const Center(child: Text("No clinic data found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ Show logo or fallback icon
              clinic.hospitalLogo != null && clinic.hospitalLogo!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        base64Decode(clinic.hospitalLogo!),
                        height: 120,
                      ),
                    )
                  : const Icon(Icons.image_not_supported,
                      size: 80, color: Colors.grey),

              const SizedBox(height: 16),

              /// ✅ Clinic Info
              Text(clinic.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(clinic.address),
              Text("City: ${clinic.city}"),
              Text("Rating: ⭐ ${clinic.hospitalOverallRating}"),
              Text("Contact: ${clinic.contactNumber}"),
              if (clinic.emailAddress != null &&
                  clinic.emailAddress!.isNotEmpty)
                Text("Email: ${clinic.emailAddress}"),
              if (clinic.website != null && clinic.website!.isNotEmpty)
                Text("Website: ${clinic.website}"),
              if (clinic.licenseNumber != null &&
                  clinic.licenseNumber!.isNotEmpty)
                Text("License: ${clinic.licenseNumber}"),
              if (clinic.issuingAuthority != null &&
                  clinic.issuingAuthority!.isNotEmpty)
                Text("Issuing Authority: ${clinic.issuingAuthority}"),
              Text("Hours: ${clinic.openingTime} - ${clinic.closingTime}"),

              if (clinic.subscription != null)
                Text("Subscription: ${clinic.subscription}"),

              if (clinic.freeFollowUps != null)
                Text("Free Follow-ups: ${clinic.freeFollowUps}"),

              if (clinic.twitterHandle != null && clinic.twitterHandle != "")
                Text("Twitter: ${clinic.twitterHandle}"),

              if (clinic.facebookHandle != null && clinic.facebookHandle != "")
                Text("Facebook: ${clinic.facebookHandle}"),

              if (clinic.instagramHandle != null &&
                  clinic.instagramHandle != "")
                Text("Instagram: ${clinic.instagramHandle}"),

              const Divider(height: 30),

              /// ✅ Show Branches if available
              if (clinic.branches != null && clinic.branches!.isNotEmpty) ...[
                Text("Branches",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                ListView.builder(
                  itemCount: clinic.branches!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final branch = clinic.branches![index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        // leading: const Icon(Icons.business, size: 32),
                        title: Text(branch.branchName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(branch.address),
                            Text("City: ${branch.city}"),
                            Text("Contact: ${branch.contactNumber}"),
                            Text("Email: ${branch.email}"),
                            Text(
                                "virtual Clinic Tour: ${branch.virtualClinicTour}"),
                          ],
                        ),
                        onTap: () {
                          // ✅ Optionally open branch location or details page
                        },
                      ),
                    );
                  },
                ),
              ] else
                const Text("No branches available"),

              const Divider(height: 30),
            ],
          ),
        );
      }),
    );
  }
}
