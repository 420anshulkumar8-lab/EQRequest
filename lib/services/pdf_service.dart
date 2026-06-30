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

    // ── Fonts ──────────────────────────────────────────────────────────
    // Using SemiCondensed-Regular for better Devanagari matra rendering
    final regularFontData = await rootBundle
        .load('assets/fonts/NotoSansDevanagari_SemiCondensed-Regular.ttf');
    final boldFontData = await rootBundle
        .load('assets/fonts/NotoSansDevanagari_SemiCondensed-SemiBold.ttf');
    final hindiRegular = pw.Font.ttf(regularFontData);
    final hindiBold    = pw.Font.ttf(boldFontData);

    // ── Images ─────────────────────────────────────────────────────────
    final irLogoData        = await rootBundle.load('assets/images/indian_railway.png');
    final ekBharatLogoData  = await rootBundle.load('assets/images/ek_bharat.png');
    final stampImgData      = await rootBundle.load('assets/images/stamp.png');
    final signatureImgData  = await rootBundle.load('assets/images/signature.png');
    final sigTextImgData    = await rootBundle.load('assets/images/signature_text.png');
    final ashokaBytes       = await rootBundle.loadString('assets/images/ashoka.svg');
    final hindiTitleData    = await rootBundle.load('assets/images/hindi_title.png');
    final hindiAddressData  = await rootBundle.load('assets/images/hindi_address.png');

    final irImage         = pw.MemoryImage(irLogoData.buffer.asUint8List());
    final ekBharatImage   = pw.MemoryImage(ekBharatLogoData.buffer.asUint8List());
    final stampImage      = pw.MemoryImage(stampImgData.buffer.asUint8List());
    final signatureImage  = pw.MemoryImage(signatureImgData.buffer.asUint8List());
    final sigTextImage      = pw.MemoryImage(sigTextImgData.buffer.asUint8List());
    final hindiTitleImage   = pw.MemoryImage(hindiTitleData.buffer.asUint8List());
    final hindiAddressImage = pw.MemoryImage(hindiAddressData.buffer.asUint8List());

    // ── Text styles ────────────────────────────────────────────────────
    final hindiBoldStyle = pw.TextStyle(font: hindiBold,    fontSize: 11);
    final hindiSmall     = pw.TextStyle(font: hindiRegular, fontSize: 9);
    final engNormal      = pw.TextStyle(fontSize: 10);
    final engBold        = pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final engSmall       = pw.TextStyle(fontSize: 9);
    final engBoldSmall   = pw.TextStyle(fontSize: 9,  fontWeight: pw.FontWeight.bold);

    final now     = DateTime.now();
    final dateStr = DateFormat('dd.MM.yyyy').format(now);

    // ── Body line based on passenger type ──────────────────────────────
    String bodyLine;
    final n = record.berthCount;
    final berthWord  = n > 1 ? 'berths' : 'berth';
    final memberWord = n > 1 ? 's' : '';
    if (record.passengerType == 'Railway Employee (On Duty)') {
      bodyLine =
          'It is requested to kindly release $n $berthWord under Emergency Quota '
          'for the following Railway staff member$memberWord proceeding on official duty:';
    } else if (record.passengerType == 'Railway Employee (Without Duty)') {
      bodyLine =
          'It is requested to kindly release $n $berthWord under Emergency Quota '
          'for the following Railway staff member$memberWord:';
    } else {
      bodyLine =
          'It is requested to kindly release $n $berthWord under Emergency Quota '
          'for the following passenger${n > 1 ? 's' : ''}:';
    }

    // ── Passenger name display ─────────────────────────────────────────
    final nameDisplay = n > 1 ? '${record.name} + ${n - 1}' : record.name;

    // ── To-office split ────────────────────────────────────────────────
    final officeParts   = record.toOffice.split('\n');
    final toDesignation = officeParts.isNotEmpty ? officeParts[0] : '';
    final toAddress =
        officeParts.length > 1 ? officeParts.sublist(1).join('\n') : '';

    // ══════════════════════════════════════════════════════════════════
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        // ↑ Margins increased on all sides
        margin: const pw.EdgeInsets.fromLTRB(60, 40, 60, 40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // ── LETTERHEAD LOGOS ───────────────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // Railway logo — increased to match Ek Bharat size
                  pw.Image(irImage, width: 80, height: 80),
                  pw.SvgImage(svg: ashokaBytes, width: 60, height: 60),
                  pw.Image(ekBharatImage, width: 80, height: 80),
                ],
              ),
              pw.SizedBox(height: 6),

              // ── OFFICE NAME (center) ───────────────────────────────
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Image(hindiTitleImage, height: 22),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Office of the Sr. Divisional Elect. Engineer (TRS)',
                      style: engBold,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Image(hindiAddressImage, height: 14),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'ई/मेल-E-mail:-gzbelstech@gmail.com',
                      style: engSmall,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Divider(thickness: 1),

              // ── PATRANK + DATE ─────────────────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Letter No.: 230-Elect./TRS/GZB/EQ Request',
                    style: engSmall,
                  ),
                  pw.Text('Date:- $dateStr', style: engSmall),
                ],
              ),
              pw.SizedBox(height: 10),

              // ── TO ADDRESS  +  ROUND STAMP (left side) ────────────
              // Stamp on left, To-address on right — exactly like reference
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(stampImage, width: 88, height: 88),
                  pw.SizedBox(width: 12),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(toDesignation, style: engBold),
                      pw.Text(toAddress,     style: engNormal),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),

              // ── SUBJECT ───────────────────────────────────────────
              pw.Center(
                child: pw.Text(
                  'Sub : Request for Release of Emergency Quota Berth',
                  style: engBold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Center(child: pw.Text('*****', style: engSmall)),
              pw.SizedBox(height: 10),

              // ── BODY ──────────────────────────────────────────────
              pw.Text(bodyLine, style: engNormal),
              pw.SizedBox(height: 12),

              // ── TABLE (centered, 70% width) ───────────────────────
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
                      _row('PNR No.',        record.pnr,          engBoldSmall, engSmall),
                      _row('Train No.',      record.trainNo,       engBoldSmall, engSmall),
                      _row('Date of Journey',record.doj,          engBoldSmall, engSmall),
                      _row('From - To',
                            '${record.fromStation} - ${record.toStation}',
                            engBoldSmall, engSmall),
                      _row('Class',    record.trainClass, engBoldSmall, engSmall),
                      _row('Name',     nameDisplay,       engBoldSmall, engSmall),
                      _row('Mobile No.',record.mobile,    engBoldSmall, engSmall),
                      _row('Reference',record.reference,  engBoldSmall, engSmall),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 16),

              // ── CLOSING LINE ──────────────────────────────────────
              pw.Text(
                'Your cooperation in this regard shall be highly appreciated.',
                style: engNormal,
              ),
              pw.SizedBox(height: 30),

              // ── SIGNATURE  (right side, slightly left from edge) ──
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(right: 18),
                    child: pw.Image(signatureImage, width: 130, height: 52),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),

              // ── OFFICER DETAILS  (right aligned, below signature) ─
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('(GAURAV GOEL)',                      style: engBoldSmall),
                      pw.Text('Sr. Divisional Electric Engineer/TRS', style: engSmall),
                      pw.Text('IRSEE',                              style: engSmall),
                      pw.Text('Electric Loco Shed, Ghaziabad',      style: engSmall),
                      pw.Text('CUG MOB: 9717631304',                style: engSmall),
                      pw.SizedBox(height: 6),
                      // ── HINDI OFFICE STAMP (signature_text.png) ──
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
    // ══════════════════════════════════════════════════════════════════

    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'EQ_${record.pnr}_${DateFormat('ddMMyyyy_HHmm').format(now)}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.TableRow _row(
    String label,
    String value,
    pw.TextStyle labelStyle,
    pw.TextStyle valueStyle,
  ) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(label, style: labelStyle),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(value, style: valueStyle),
        ),
      ],
    );
  }
}
