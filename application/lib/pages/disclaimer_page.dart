import 'package:application/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:io';

class DisclaimerPage extends StatefulWidget {
  const DisclaimerPage({super.key});

  @override
  State<DisclaimerPage> createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  String? localPath; // Use nullable type

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final ByteData bytes =
          await rootBundle.load('assets/images/disclaimer.pdf');
      final Uint8List list = bytes.buffer.asUint8List();

      final tempDir = await Directory.systemTemp.createTemp();
      final file = File('${tempDir.path}/disclaimer.pdf');

      await file.writeAsBytes(list, flush: true);
      setState(() {
        localPath = file.path;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error loading PDF: $e'); // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      extendBodyBehindAppBar: true, // Allow body to extend behind AppBar
      body: localPath != null
          ? PDFView(
              filePath: localPath,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
