import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../models/bill.dart';
import '../../utils/print.dart';

class PreviewBillPage extends StatelessWidget {
  static const String route = '/preview-bill';

  final KiaanAyurvedaBill bill;

  const PreviewBillPage({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        foregroundColor: Colors.black,
        title: Text('Invoice ${bill.invoiceNo}'),
      ),
      body: PdfPreview(
        build: (format) => previewBill(format, bill),
        allowPrinting: true,
        allowSharing: false,
        canDebug: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        enableScrollToPage: true,
        useActions: true,
        pdfFileName: 'Invoice ${bill.invoiceNo}',
        actions: [
          PdfPreviewAction(
            icon: const Icon(Icons.share),
            onPressed: (context, build, pageFormat) => shareBill(bill),
          ),
        ],
      ),
    );
  }
}
