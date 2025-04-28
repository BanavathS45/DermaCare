import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class FilePreviewScreen extends StatefulWidget {
  final String fileUrl;

  const FilePreviewScreen({super.key, required this.fileUrl});

  @override
  State<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadTempFile();
  }

  Future<void> _downloadTempFile() async {
    final fileName = widget.fileUrl.split('/').last;
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/$fileName");

    final response = await http.get(Uri.parse(widget.fileUrl));
    await file.writeAsBytes(response.bodyBytes);

    setState(() {
      localPath = file.path;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = widget.fileUrl.toLowerCase().endsWith('.pdf');

    return Scaffold(
      appBar: AppBar(title: const Text("Preview")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isPdf
              ? PDFView(
                  filePath: localPath!,
                  autoSpacing: true,
                  swipeHorizontal: false,
                )
              : PhotoView(
                  imageProvider: FileImage(File(localPath!)),
                ),
    );
  }
}
