import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../data/railway_data.dart';
import '../models/eq_record.dart';
import '../services/pdf_service.dart';
import '../services/pnr_service.dart';
import '../widgets/searchable_dropdown.dart';
import 'pdf_preview_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _pnrCtrl = TextEditingController();
  final _trainCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _referenceCtrl = TextEditingController();

  String? _doj;
  String? _selectedClass;
  String? _passengerType;
  int _berthCount = 1;
  RailwayOffice? _selectedOffice;
  String? _customOfficeText;
  bool _isFetching = false;

  final List<String> _classes = ['1AC', '2AC', '3AC', 'SL', 'CC', 'ECC', '3AC-E'];
  final List<String> _passengerTypes = [
    'Railway Employee (On Duty)',
    'Railway Employee (Without Duty)',
    'Civilian',
  ];

  Future<void> _fetchPnrDetails() async {
    final pnr = _pnrCtrl.text.trim();
    if (pnr.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit PNR'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isFetching = true);

    final details = await PnrService.fetchPnrDetails(pnr);

    setState(() {
      _isFetching = false;
      if (details.success) {
        _trainCtrl.text = details.trainNo;
        _doj = details.doj;
        _fromCtrl.text = details.from;
        _toCtrl.text = details.to;
        _selectedClass = _mapClass(details.trainClass);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(details.error ?? 'Could not fetch. Please fill manually.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  String? _mapClass(String raw) {
    final r = raw.toUpperCase();
    if (_classes.contains(r)) return r;
    if (r == '3E') return '3AC-E';
    if (r == 'SL') return 'SL';
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );
    if (picked != null) {
      setState(() {
        _doj = DateFormat('dd-MM-yy').format(picked);
      });
    }
  }

  Future<void> _generatePdf() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedOffice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select To office'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_selectedOffice!.zone == 'OTH' && (_customOfficeText == null || _customOfficeText!.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter office address'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_doj == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Date of Journey'), backgroundColor: Colors.red),
      );
      return;
    }

    // Build toOffice string
    String toOffice = '';
    if (_selectedOffice!.zone == 'OTH') {
      toOffice = _customOfficeText ?? '';
    } else {
      toOffice = '${_selectedOffice!.designation}\n${_selectedOffice!.office}';
    }

    final record = EqRecord()
      ..pnr = _pnrCtrl.text.trim()
      ..trainNo = _trainCtrl.text.trim()
      ..doj = _doj!
      ..fromStation = _fromCtrl.text.trim().toUpperCase()
      ..toStation = _toCtrl.text.trim().toUpperCase()
      ..trainClass = _selectedClass!
      ..name = _nameCtrl.text.trim()
      ..mobile = _mobileCtrl.text.trim()
      ..reference = _referenceCtrl.text.trim()
      ..passengerType = _passengerType!
      ..berthCount = _berthCount
      ..toOffice = toOffice
      ..zone = _selectedOffice!.zone
      ..createdAt = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
      ..pdfPath = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final file = await PdfService.generatePdf(record);
      record.pdfPath = file.path;

      final box = Hive.box<EqRecord>('records');
      await box.add(record);

      if (mounted) Navigator.pop(context);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PdfPreviewScreen(record: record, pdfFile: file)),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text('New EQ Request'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // TO OFFICE
            _SectionHeader(title: 'To (Addressee)'),
            SearchableOfficeDropdown(
              selected: _selectedOffice,
              customOfficeText: _customOfficeText,
              onSelected: (o, customText) => setState(() {
                _selectedOffice = o;
                _customOfficeText = customText;
              }),
            ),
            const SizedBox(height: 16),

            // PNR + FETCH
            _SectionHeader(title: 'PNR Details'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _pnrCtrl,
                    label: 'PNR No.',
                    hint: '10-digit PNR',
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => v == null || v.length != 10 ? 'Enter valid 10-digit PNR' : null,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _isFetching ? null : _fetchPnrDetails,
                  icon: _isFetching
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.search, size: 18),
                  label: const Text('Fetch'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Train No
            _buildTextField(
              controller: _trainCtrl,
              label: 'Train No.',
              hint: '5-digit train number',
              maxLength: 5,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),

            // DOJ
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      _doj ?? 'Date of Journey',
                      style: TextStyle(
                        fontSize: 14,
                        color: _doj == null ? Colors.grey.shade500 : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // From - To
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _fromCtrl,
                    label: 'From',
                    hint: 'NDLS',
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]'))],
                    validator: (v) => v == null || v.length < 2 ? 'Min 2 chars' : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    controller: _toCtrl,
                    label: 'To',
                    hint: 'GKP',
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]'))],
                    validator: (v) => v == null || v.length < 2 ? 'Min 2 chars' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Class
            _buildDropdown(
              label: 'Class',
              value: _selectedClass,
              items: _classes,
              onChanged: (v) => setState(() => _selectedClass = v),
              validator: (v) => v == null ? 'Select class' : null,
            ),
            const SizedBox(height: 16),

            // PASSENGER DETAILS
            _SectionHeader(title: 'Passenger Details'),
            _buildTextField(
              controller: _nameCtrl,
              label: 'Name',
              hint: 'Sh. Govind Sharma',
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _mobileCtrl,
              label: 'Mobile No.',
              hint: '10-digit mobile',
              maxLength: 10,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => v == null || v.length != 10 ? 'Enter valid 10-digit number' : null,
            ),
            const SizedBox(height: 10),

            _buildDropdown(
              label: 'No. of Berths',
              value: _berthCount.toString(),
              items: ['1', '2', '3', '4', '5'],
              onChanged: (v) => setState(() => _berthCount = int.parse(v!)),
            ),
            const SizedBox(height: 10),

            _buildDropdown(
              label: 'Passenger Type',
              value: _passengerType,
              items: _passengerTypes,
              onChanged: (v) => setState(() => _passengerType = v),
              validator: (v) => v == null ? 'Select type' : null,
            ),
            const SizedBox(height: 10),

            _buildTextField(
              controller: _referenceCtrl,
              label: 'Reference',
              hint: 'SSE/ELS/GZB',
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),

            // Generate Button
            ElevatedButton.icon(
              onPressed: _generatePdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generate EQ Letter', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int? maxLength,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
