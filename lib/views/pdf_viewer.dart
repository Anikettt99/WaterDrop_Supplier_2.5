import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  PdfViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Terms Conditions & Privacy Policy',
          style: TextStyle(
            fontSize: 15
          ),

        ),

      ),
      body: SfPdfViewer.asset('assets/terms_conditions.pdf'),
    );
  }
}
