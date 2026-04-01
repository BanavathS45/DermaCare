import 'package:cutomer_app/Utils/ShowSnackBar%20copy.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

Future<void> downloadAndOpenReport(String fileUrl) async {
  try {
    final fileName = fileUrl.split('/').last; // Extract name from URL
    final tempDir = await getTemporaryDirectory();
    final savePath = "${tempDir.path}/$fileName";

    print("Downloading: $fileUrl");
    print("Saving to: $savePath");

    Dio dio = Dio();
    await dio.download(fileUrl, savePath);

    showSnackbar("Success", "Report downloaded successfully!", "success");
    await OpenFile.open(savePath);
  } catch (e) {
    print("⛔ Download error: $e");
    showSnackbar("Error", "Failed to download report", "error");
  }
}
