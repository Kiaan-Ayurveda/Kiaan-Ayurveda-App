import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../models/bill.dart';

late Font hind;
late Font hindBold;

List<List<String>> _getBillData(KiaanAyurvedaBill bill) {
  final List<List<String>> data = <List<String>>[
    <String>[
      '#',
      'Description',
      if (bill.isGstBill) 'HSN/SAC',
      'Quantity',
      'Rate/Unit',
      'Amount'
    ]
  ];

  for (int i = 0; i < bill.items.length; i++) {
    final item = bill.items[i];
    data.add(<String>[
      (i + 1).toString(),
      item.description!,
      if (bill.isGstBill) item.hsnSac ?? '',
      // item.quantity.toString(),
      '${item.quantity}',
      item.rateInRupees,
      item.amountInRupees,
    ]);
  }

  return data;
}

Future<Uint8List> billDoc(
  KiaanAyurvedaBill bill,
) async {
  hind = await PdfGoogleFonts.hindRegular();
  hindBold = await PdfGoogleFonts.hindBold();

  final signImg = MemoryImage(
    (await rootBundle.load('assets/sign.png')).buffer.asUint8List(),
  );

  final watermarkImg = await rootBundle.loadString('assets/kiaan.svg');

  final doc = Document(
    title: 'Invoice ${bill.invoiceNo}',
    version: PdfVersion.pdf_1_5,
    pageMode: PdfPageMode.fullscreen,
  );

  doc.addPage(
    MultiPage(
      header: (Context context) => Column(
        children: <Widget>[
          Header(
            level: 3,
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'KIAAN AYURVEDA',
                        textScaleFactor: 2,
                        style: TextStyle(
                          font: hindBold,
                          letterSpacing: 1.1,
                          wordSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Flat no. 20, Niyoshi Park 2 Sanghvi Nagar',
                        style: TextStyle(font: hind),
                      ),
                      Text(
                        'Ward no.8, Bremen chowk, Aundh',
                        style: TextStyle(font: hind),
                      ),
                      Text(
                        'Pune, Maharashtra. 411007',
                        style: TextStyle(font: hind),
                      ),
                      if (bill.isGstBill) ...[
                        SizedBox(height: 5),
                        Text(
                          'GSTIN: 27AJDPD3882D2ZF',
                          style: TextStyle(font: hind),
                        ),
                      ],
                      SizedBox(height: 5),
                      Text(
                        'Email: cc.kiaanayurveda@gmail.com',
                        style: TextStyle(font: hind),
                      ),
                      Text(
                        'Mob: 9881070648',
                        style: TextStyle(font: hind),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    'Invoice',
                    textScaleFactor: 1.5,
                    style: TextStyle(font: hind),
                  ),
                ),
              ],
            ),
          ),
          // To
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'To',
                      style: TextStyle(font: hindBold),
                    ),
                    Text(
                      bill.to,
                      style: TextStyle(font: hind),
                    ),
                    Text(
                      bill.toAddress,
                      style: TextStyle(font: hind),
                    ),
                    if (bill.toGst != null) ...[
                      SizedBox(height: 5),
                      Text(
                        'GSTIN: ${bill.toGst}',
                        style: TextStyle(font: hind),
                      ),
                    ],
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TableHelper.fromTextArray(
                      data: <List<String>>[
                        <String>['Invoice No', bill.invoiceNo],
                        <String>['Date', bill.invoiceDate],
                      ],
                      cellAlignments: {
                        0: Alignment.centerLeft,
                        1: Alignment.centerLeft,
                      },
                      columnWidths: {
                        0: const FlexColumnWidth(5),
                        1: const FlexColumnWidth(7),
                      },
                      headerCount: 0,
                      cellStyle: TextStyle(
                        font: hind,
                        fontFallback: [hind],
                      ),
                      border: const TableBorder(
                        top: BorderSide(
                          color: PdfColors.grey,
                          width: .5,
                        ),
                        horizontalInside: BorderSide(
                          color: PdfColors.grey,
                          width: .25,
                        ),
                        bottom: BorderSide(
                          color: PdfColors.grey,
                          width: .5,
                        ),
                      ),
                      cellPadding: const EdgeInsets.only(
                        top: 2,
                        bottom: 1,
                        left: 5,
                        right: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
        ],
      ),
      build: (Context context) {
        return [
          // Invoice
          TableHelper.fromTextArray(
            data: _getBillData(bill),
            cellAlignments: bill.isGstBill
                ? {
                    0: Alignment.center,
                    1: Alignment.centerLeft,
                    2: Alignment.centerLeft,
                    3: Alignment.centerRight,
                    4: Alignment.centerRight,
                    5: Alignment.centerRight,
                  }
                : {
                    0: Alignment.center,
                    1: Alignment.centerLeft,
                    2: Alignment.centerRight,
                    3: Alignment.centerRight,
                    4: Alignment.centerRight,
                  },
            columnWidths: bill.isGstBill
                ? {
                    0: const FlexColumnWidth(1),
                    1: const FlexColumnWidth(5),
                    2: const FlexColumnWidth(2),
                    3: const FlexColumnWidth(2),
                    4: const FlexColumnWidth(2),
                    5: const FlexColumnWidth(3),
                  }
                : {
                    0: const FlexColumnWidth(1),
                    1: const FlexColumnWidth(6),
                    2: const FlexColumnWidth(2),
                    3: const FlexColumnWidth(2),
                    4: const FlexColumnWidth(3),
                  },
            headerStyle: TextStyle(font: hindBold),
            cellStyle: TextStyle(
              fontWeight: FontWeight.normal,
              font: hind,
              fontFallback: [
                hind,
              ],
            ),
            headerDecoration: const BoxDecoration(color: PdfColors.grey100),
            border: const TableBorder(
              horizontalInside: BorderSide(
                color: PdfColors.grey,
                width: .5,
              ),
              top: BorderSide(
                color: PdfColors.grey,
                width: .5,
              ),
              bottom: BorderSide(
                color: PdfColors.grey,
                width: .5,
              ),
            ),
            cellPadding: const EdgeInsets.only(
              top: 3,
              bottom: 2,
              left: 5,
              right: 5,
            ),
          ),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 7,
                fit: FlexFit.tight,
                child: Container(
                  padding: const EdgeInsets.only(top: 12, right: 20),
                  child: Text(
                    'Certified that the particulars given above are true and correct.',
                    style: TextStyle(
                      font: hind,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: TableHelper.fromTextArray(
                  data: <List<String>>[
                    <String>['Total', bill.totalAmountInRupees],
                    if (bill.isGstBill) ...[
                      <String>['CGST 9%', bill.cgstInRupees],
                      <String>['SGST 9%', bill.sgstInRupees],
                      <String>['Grand Total', bill.grandTotalInRupees],
                    ]
                  ],
                  cellAlignments: {
                    0: Alignment.centerRight,
                    1: Alignment.centerRight,
                  },
                  columnWidths: bill.isGstBill
                      ? {
                          0: const FlexColumnWidth(3),
                          1: const FlexColumnWidth(4),
                        }
                      : {
                          0: const FlexColumnWidth(2),
                          1: const FlexColumnWidth(3),
                        },
                  headerCount: 0,
                  cellStyle: TextStyle(
                    font: hind,
                    fontFallback: [
                      hind,
                    ],
                  ),
                  border: const TableBorder(
                    horizontalInside: BorderSide(
                      color: PdfColors.grey,
                      width: .5,
                    ),
                    bottom: BorderSide(
                      color: PdfColors.grey,
                      width: .5,
                    ),
                  ),
                  cellPadding: const EdgeInsets.only(
                    top: 3,
                    bottom: 2,
                    left: 5,
                    right: 5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          // Total in words
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Total in words:',
                style: TextStyle(font: hindBold),
              ),
              SizedBox(width: 5),
              Text(
                bill.amountInWords,
                style: TextStyle(font: hind),
              ),
            ],
          ),
        ];
      },
      footer: (context) => Column(
        children: [
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '    Recevier\'s Signature',
                style: TextStyle(font: hind),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'For KIAAN AYURVEDA',
                    style: TextStyle(font: hindBold),
                  ),
                  SizedBox(height: 5),
                  // Image
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: Image(
                      signImg,
                      width: 100,
                      height: 50,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Authorised Signature  ',
                    style: TextStyle(font: hind),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          // Page number
          context.pagesCount == 1
              ? SizedBox(height: 10)
              : Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: TextStyle(
                      font: hind,
                      fontSize: 8,
                    ),
                  ),
                ),
        ],
      ),
      pageTheme: PageTheme(
        margin: const EdgeInsets.only(
          left: 50,
          right: 50,
          top: 50,
          bottom: 30,
        ),
        buildBackground: (Context context) => FullPage(
          ignoreMargins: true,
          child: Center(
            child: Opacity(
              opacity: 0.175,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgImage(
                    svg: watermarkImg,
                    width: 300,
                    height: 300,
                  ),
                  Text(
                    'KIAAN',
                    textScaleFactor: 5.5,
                    style: TextStyle(
                      letterSpacing: 3,
                      wordSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: const PdfColor(35 / 255, 31 / 255, 32 / 255),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 14,
                        height: 3,
                        color: const PdfColor(35 / 255, 31 / 255, 32 / 255),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'AYURVEDA',
                        textScaleFactor: 2,
                        style: TextStyle(
                          letterSpacing: 3,
                          wordSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: const PdfColor(35 / 255, 31 / 255, 32 / 255),
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 3,
                        color: const PdfColor(35 / 255, 31 / 255, 32 / 255),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  return doc.save();
}

Future<Uint8List> previewBill(
  PdfPageFormat format,
  KiaanAyurvedaBill bill,
) async {
  return billDoc(bill);
}

void printBill(KiaanAyurvedaBill bill) async {
  final doc = await billDoc(bill);
  await Printing.layoutPdf(
    name: 'Invoice ${bill.invoiceNo}.pdf',
    onLayout: (PdfPageFormat format) async => doc,
  );
}

void shareBill(KiaanAyurvedaBill bill) async {
  final doc = await billDoc(bill);
  Printing.sharePdf(
    bytes: doc,
    filename: 'Invoice ${bill.invoiceNo}.pdf',
    emails: bill.toEmail != null ? [bill.toEmail!] : null,
    subject:
        'Kiaan Ayurveda Invoice ${bill.invoiceNo} dated ${bill.invoiceDate}',
    body: 'Kiaan Ayurveda Invoice ${bill.invoiceNo}\n'
        'Date: ${bill.invoiceDate}\n'
        'To: ${bill.to}\n'
        'Total: ${bill.totalAmountInRupees}\n'
        '${bill.isGstBill ? 'CGST 9%: ${bill.cgstInRupees}\nSGST 9%: ${bill.sgstInRupees}\nGrand Total: ${bill.grandTotalInRupees}\n' : ''}'
        'Amount in words: ${bill.amountInWords}\n\n'
        'Please find the attached invoice for your reference.\n\n'
        'Thank you,\n\n'
        'Kiaan Ayurveda\n'
        'Flat no. 20, Niyoshi Park 2 Sanghvi Nagar\n'
        'Ward no.8, Bremen chowk, Aundh\n'
        'Pune, Maharashtra. 411007\n'
        'Email: cc.kiaanayurveda@gmail.com\n'
        'Mob: 9881070648\n',
  );
}
