import 'package:cutomer_app/Doctors/ListOfDoctors/HospitalAndDoctorModel.dart';
import 'package:flutter/material.dart';

class BranchSelectionSheet extends StatelessWidget {
  final List<Branch> branches; // ✅ Use Branch model

  const BranchSelectionSheet({super.key, required this.branches});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Select a Branch",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(branches.length, (index) {
            final branch = branches[index];
            return ListTile(
              title:
                  Text(branch.branchName, style: const TextStyle(fontSize: 14)),
              leading: const Icon(Icons.local_hospital_outlined,
                  color: Colors.redAccent),
              onTap: () {
                Navigator.pop(
                    context, index); // ✅ Return index (or branch itself)
              },
            );
          }),
        ],
      ),
    );
  }
}
