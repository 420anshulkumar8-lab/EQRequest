import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/eq_record.dart';
import '../services/pdf_service.dart';
import 'pdf_preview_screen.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text('Old Records'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search by PNR, Name, Date...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
          // Records list
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<EqRecord>('records').listenable(),
              builder: (context, Box<EqRecord> box, _) {
                var records = box.values.toList().reversed.toList();

                // Filter
                if (_query.isNotEmpty) {
                  records = records.where((r) =>
                    r.pnr.toLowerCase().contains(_query) ||
                    r.name.toLowerCase().contains(_query) ||
                    r.createdAt.contains(_query) ||
                    r.trainNo.contains(_query),
                  ).toList();
                }

                if (records.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No records found', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                // Group by date
                final Map<String, List<EqRecord>> grouped = {};
                for (final r in records) {
                  final date = r.createdAt.split(' ')[0];
                  grouped.putIfAbsent(date, () => []).add(r);
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: grouped.entries.map((entry) {
                    final date = entry.key;
                    final dayRecords = entry.value;
                    // Format date nicely
                    String displayDate = date;
                    try {
                      final dt = DateFormat('yyyy-MM-dd').parse(date);
                      displayDate = DateFormat('dd MMM yyyy, EEEE').format(dt);
                    } catch (_) {}

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            displayDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        ),
                        ...dayRecords.map((record) => _RecordCard(record: record)),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final EqRecord record;
  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1A237E),
          child: Text(
            record.zone.substring(0, 2),
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          'PNR: ${record.pnr}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${record.name} • Train ${record.trainNo}', style: const TextStyle(fontSize: 12)),
            Text('${record.fromStation} → ${record.toStation} • ${record.doj}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () async {
          // Open existing PDF or regenerate
          final file = File(record.pdfPath);
          File pdfFile;
          if (await file.exists()) {
            pdfFile = file;
          } else {
            // Regenerate
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
            pdfFile = await PdfService.generatePdf(record);
            if (context.mounted) Navigator.pop(context);
          }
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PdfPreviewScreen(record: record, pdfFile: pdfFile),
              ),
            );
          }
        },
      ),
    );
  }
}
