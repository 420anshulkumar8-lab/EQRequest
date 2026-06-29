import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/eq_record.dart';

class PdfService {
  static Future<File> generatePdf(EqRecord record) async {
    final pdf = pw.Document();

    // ── Fonts ─────────────────────────────────────────────────────────
    final regularFontData = await rootBundle
        .load('assets/fonts/NotoSansDevanagari_SemiCondensed-Regular.ttf');
    final boldFontData = await rootBundle
        .load('assets/fonts/NotoSansDevanagari_SemiCondensed-SemiBold.ttf');
    final hindiRegular = pw.Font.ttf(regularFontData);
    final hindiBold    = pw.Font.ttf(boldFontData);

    // ── Images ────────────────────────────────────────────────────────
    final irLogoData       = await rootBundle.load('assets/images/indian_railway.png');
    final ekBharatData     = await rootBundle.load('assets/images/ekbharat_logo.png');
    final stampRoundData   = await rootBundle.load('assets/images/stamp_round.png');
    final signatureData    = await rootBundle.load('assets/images/signature.png');
    final sigTextData      = await rootBundle.load('assets/images/signature_text.png');
    final ashokaBytes      = await rootBundle.loadString('assets/images/ashoka.svg');
    final hindiTitleData   = await rootBundle.load('assets/images/hindi_title.png');
    final hindiAddressData = await rootBundle.load('assets/images/hindi_address.png');

    final irImage        = pw.MemoryImage(irLogoData.buffer.asUint8List());
    final ekBharatImage  = pw.MemoryImage(ekBharatData.buffer.asUint8List());
    final stampImage     = pw.MemoryImage(stampRoundData.buffer.asUint8List());
    final signatureImage = pw.MemoryImage(signatureData.buffer.asUint8List());
    final sigTextImage   = pw.MemoryImage(sigTextData.buffer.asUint8List());
    final hindiTitleImg  = pw.MemoryImage(hindiTitleData.buffer.asUint8List());
    final hindiAddrImg   = pw.MemoryImage(hindiAddressData.buffer.asUint8List());

    // ── Text styles ───────────────────────────────────────────────────
    final engNormal    = pw.TextStyle(fontSize: 10);
    final engBold      = pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final engSmall     = pw.TextStyle(fontSize: 9);
    final engBoldSmall = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);

    final now     = DateTime.now();
    final dateStr = DateFormat('dd.MM.yyyy').format(now);

    // ── Body line ─────────────────────────────────────────────────────
    final n = record.berthCount;
    final berthWord  = n > 1 ? 'berths' : 'berth';
    final memberWord = n > 1 ? 's' : '';
    String bodyLine;
    if (record.passengerType == 'Railway Employee (On Duty)') {
      bodyLine = 'It is requested to kindly release $n $berthWord under Emergency Quota '
          'for the following Railway staff member$memberWord proceeding on official duty:';
    } else if (record.passengerType == 'Railway Employee (Without Duty)') {
      bodyLine = 'It is requested to kindly release $n $berthWord under Emergency Quota '
          'for the following Railway staff member$memberWord:';
    } else {
      bodyLine = 'It is requested to kindly release $n $berthWord under Emergency Quota '
          'for the following passenger${n > 1 ? 's' : ''}:';
    }

    final nameDisplay = n > 1 ? '${record.name} + ${n - 1}' : record.name;

    final officeParts   = record.toOffice.split('\n');
    final toDesignation = officeParts.isNotEmpty ? officeParts[0] : '';
    final toAddress     = officeParts.length > 1 ? officeParts.sublist(1).join('\n') : '';

    // ═════════════════════════════════════════════════════════════════
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(60, 40, 60, 40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // ── LETTERHEAD LOGOS ─────────────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(irImage,       width: 80, height: 80),
                  pw.SvgImage(svg: ashokaBytes, width: 60, height: 60),
                  pw.Image(ekBharatImage, width: 80, height: 80), // Ek Bharat top-right ✅
                ],
              ),
              pw.SizedBox(height: 6),

              // ── OFFICE NAME ──────────────────────────────────────
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Image(hindiTitleImg, height: 22),
                    pw.SizedBox(height: 2),
                    pw.Text('Office of the Sr. Divisional Elect. Engineer (TRS)',
                        style: engBold),
                    pw.SizedBox(height: 2),
                    pw.Image(hindiAddrImg, height: 14),
                    pw.SizedBox(height: 2),
                    pw.Text('E-mail:- gzbelstech@gmail.com', style: engSmall),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Divider(thickness: 1),

              // ── LETTER NO. + DATE ────────────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Letter No.: 230-Elect./TRS/GZB/EQ Request',
                      style: engSmall),
                  pw.Text('Date:- $dateStr', style: engSmall),
                ],
              ),
              pw.SizedBox(height: 8),

              // ── TO ADDRESS + ROUND STAMP OVERLAY ────────────────
              // Stack: To-address on left, round stamp floating center-right
              pw.SizedBox(
                height: 95,
                child: pw.Stack(
                  children: [
                    // To address — left side
                    pw.Positioned(
                      left: 0, top: 8,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(toDesignation, style: engBold),
                          pw.Text(toAddress,     style: engNormal),
                        ],
                      ),
                    ),
                    // Round stamp — center-right overlay ✅
                    pw.Positioned(
                      right: 60, top: 0,
                      child: pw.Image(stampImage, width: 90, height: 90),
                    ),
                  ],
                ),
              ),

              // ── SUBJECT ──────────────────────────────────────────
              pw.Center(
                child: pw.Text(
                  'Sub : Request for Release of Emergency Quota Berth',
                  style: engBold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Center(child: pw.Text('*****', style: engSmall)),
              pw.SizedBox(height: 10),

              // ── BODY ─────────────────────────────────────────────
              pw.Text(bodyLine, style: engNormal),
              pw.SizedBox(height: 12),

              // ── TABLE ────────────────────────────────────────────
              pw.Center(
                child: pw.SizedBox(
                  width: 380,
                  child: pw.Table(
                    border: pw.TableBorder.all(width: 0.5),
                    columnWidths: const {
                      0: pw.FixedColumnWidth(120),
                      1: pw.FixedColumnWidth(260),
                    },
                    children: [
                      _row('PNR No.',         record.pnr,         engBoldSmall, engSmall),
                      _row('Train No.',       record.trainNo,     engBoldSmall, engSmall),
                      _row('Date of Journey', record.doj,         engBoldSmall, engSmall),
                      _row('From - To',
                           '${record.fromStation} - ${record.toStation}',
                           engBoldSmall, engSmall),
                      _row('Class',     record.trainClass, engBoldSmall, engSmall),
                      _row('Name',      nameDisplay,       engBoldSmall, engSmall),
                      _row('Mobile No.',record.mobile,     engBoldSmall, engSmall),
                      _row('Reference', record.reference,  engBoldSmall, engSmall),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 16),

              // ── CLOSING LINE ─────────────────────────────────────
              pw.Text(
                'Your cooperation in this regard shall be highly appreciated.',
                style: engNormal,
              ),
              pw.SizedBox(height: 30),

              // ── SIGNATURE (right side) ───────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Image(signatureImage, width: 130, height: 52),
                ],
              ),
              pw.SizedBox(height: 4),

              // ── OFFICER DETAILS (right aligned) ──────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('(GAURAV GOEL)',                        style: engBoldSmall),
                      pw.Text('Sr. Divisional Electric Engineer/TRS', style: engSmall),
                      pw.Text('IRSEE',                                style: engSmall),
                      pw.Text('Electric Loco Shed, Ghaziabad',        style: engSmall),
                      pw.Text('CUG MOB: 9717631304',                  style: engSmall),
                      pw.SizedBox(height: 6),
                      pw.Image(sigTextImage, width: 130, height: 57),
                    ],
                  ),
                ],
              ),

            ],
          );
        },
      ),
    );
    // ═════════════════════════════════════════════════════════════════

    final dir      = await getApplicationDocumentsDirectory();
    final fileName = 'EQ_${record.pnr}_${DateFormat('ddMMyyyy_HHmm').format(now)}.pdf';
    final file     = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.TableRow _row(String label, String value,
      pw.TextStyle labelStyle, pw.TextStyle valueStyle) {
    return pw.TableRow(children: [
      pw.Padding(padding: const pw.EdgeInsets.all(5),
          child: pw.Text(label, style: labelStyle)),
      pw.Padding(padding: const pw.EdgeInsets.all(5),
          child: pw.Text(value, style: valueStyle)),
    ]);
  }
}
