import 'dart:convert';
import 'package:http/http.dart' as http;

class PnrDetails {
  final String trainNo;
  final String trainName;
  final String doj;
  final String from;
  final String to;
  final String trainClass;
  final bool success;
  final String? error;

  PnrDetails({
    required this.trainNo,
    required this.trainName,
    required this.doj,
    required this.from,
    required this.to,
    required this.trainClass,
    required this.success,
    this.error,
  });
}

class PnrService {
  static const String _apiKey = '7122bceb4bmsh0ca890f011978ffp19633fjsnb08b3e1e3996';
  static const String _apiHost = 'irctc-indian-railway-pnr-status.p.rapidapi.com';

  static Future<PnrDetails> fetchPnrDetails(String pnr) async {
    try {
      final response = await http.get(
        Uri.parse('https://$_apiHost/getPNRStatus/$pnr'),
        headers: {
          'x-rapidapi-key': _apiKey,
          'x-rapidapi-host': _apiHost,
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Check if API returned success: true and data is not null
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final data = jsonResponse['data'];

          final trainNo = data['trainNumber']?.toString() ?? '';
          final trainName = data['trainName']?.toString() ?? ''; 
          final doj = _formatDate(data['dateOfJourney']?.toString() ?? '');
          final from = data['boardingPoint']?.toString() ?? '';
          final to = data['reservationUpto']?.toString() ?? '';
          final cls = data['journeyClass']?.toString() ?? '';

          if (trainNo.isNotEmpty) {
            return PnrDetails(
              trainNo: trainNo,
              trainName: trainName,
              doj: doj,
              from: from,
              to: to,
              trainClass: _mapClass(cls),
              success: true,
            );
          } else {
            return PnrDetails(
              trainNo: '', trainName: '', doj: '', from: '', to: '', trainClass: '',
              success: false,
              error: 'PNR not found. Please fill manually.',
            );
          }
        } else {
          return PnrDetails(
            trainNo: '', trainName: '', doj: '', from: '', to: '', trainClass: '',
            success: false,
            error: 'Invalid response from API. Please fill manually.',
          );
        }
      } else if (response.statusCode == 429) {
        return PnrDetails(
          trainNo: '', trainName: '', doj: '', from: '', to: '', trainClass: '',
          success: false,
          error: 'API limit reached. Please fill manually.',
        );
      } else {
        return PnrDetails(
          trainNo: '', trainName: '', doj: '', from: '', to: '', trainClass: '',
          success: false,
          error: 'Error ${response.statusCode}. Please fill manually.',
        );
      }
    } catch (e) {
      return PnrDetails(
        trainNo: '', trainName: '', doj: '', from: '', to: '', trainClass: '',
        success: false,
        error: 'Network error. Please fill manually.',
      );
    }
  }

  // Date formatter to handle "Jul 23, 2026 6:00:00 PM"
  static String _formatDate(String raw) {
    try {
      if (raw.isEmpty) return '';
      
      final parts = raw.split(' ');
      if (parts.length >= 3) {
        final monthStr = parts[0]; 
        final dayStr = parts[1].replaceAll(',', ''); 
        final yearStr = parts[2]; 

        const months = {
          'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
          'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
          'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
        };

        final month = months[monthStr] ?? monthStr;
        final year = yearStr.length == 4 ? yearStr.substring(2) : yearStr;

        return '${dayStr.padLeft(2, '0')}-$month-$year';
      }
      return raw;
    } catch (_) {
      return raw; 
    }
  }

  static String _mapClass(String raw) {
    final r = raw.toUpperCase().trim();
    const classMap = {
      '1A': '1AC',
      '2A': '2AC',
      '3A': '3AC',
      '3E': '3AC-E',
      'SL': 'SL',
      'CC': 'CC',
      'EC': 'ECC',
      'ECC': 'ECC',
      '1AC': '1AC',
      '2AC': '2AC',
      '3AC': '3AC',
    };
    return classMap[r] ?? r;
  }
}
