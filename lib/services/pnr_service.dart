import 'dart:convert';
import 'package:http/http.dart' as http;

class PnrDetails {
  final String trainNo;
  final String doj;
  final String from;
  final String to;
  final String trainClass;
  final bool success;
  final String? error;

  PnrDetails({
    required this.trainNo,
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
        final data = json.decode(response.body);

        // Response parse karo
        if (data != null) {
          final trainNo = data['trainNumber']?.toString() ??
              data['TrainNo']?.toString() ??
              data['train_number']?.toString() ?? '';

          final doj = _formatDate(
            data['dateOfJourney']?.toString() ??
            data['DateOfJourney']?.toString() ??
            data['doj']?.toString() ?? '',
          );

          final from = data['boardingStationCode']?.toString() ??
              data['BoardingPoint']?.toString() ??
              data['from']?.toString() ??
              data['sourceStation']?.toString() ?? '';

          final to = data['reservationUpto']?.toString() ??
              data['DestinationStation']?.toString() ??
              data['to']?.toString() ??
              data['destinationStation']?.toString() ?? '';

          final cls = data['class']?.toString() ??
              data['Class']?.toString() ??
              data['classCode']?.toString() ?? '';

          if (trainNo.isNotEmpty) {
            return PnrDetails(
              trainNo: trainNo,
              doj: doj,
              from: from,
              to: to,
              trainClass: _mapClass(cls),
              success: true,
            );
          } else {
            return PnrDetails(
              trainNo: '', doj: '', from: '', to: '', trainClass: '',
              success: false,
              error: 'PNR not found. Please fill manually.',
            );
          }
        } else {
          return PnrDetails(
            trainNo: '', doj: '', from: '', to: '', trainClass: '',
            success: false,
            error: 'Invalid response. Please fill manually.',
          );
        }
      } else if (response.statusCode == 429) {
        return PnrDetails(
          trainNo: '', doj: '', from: '', to: '', trainClass: '',
          success: false,
          error: 'API limit reached. Please fill manually.',
        );
      } else {
        return PnrDetails(
          trainNo: '', doj: '', from: '', to: '', trainClass: '',
          success: false,
          error: 'Error ${response.statusCode}. Please fill manually.',
        );
      }
    } catch (e) {
      return PnrDetails(
        trainNo: '', doj: '', from: '', to: '', trainClass: '',
        success: false,
        error: 'Network error. Please fill manually.',
      );
    }
  }

  static String _formatDate(String raw) {
    try {
      if (raw.isEmpty) return '';
      // DD-MM-YYYY format
      if (raw.contains('-')) {
        final parts = raw.split('-');
        if (parts.length == 3) {
          if (parts[0].length == 4) {
            // YYYY-MM-DD → DD-MM-YY
            return '${parts[2]}-${parts[1]}-${parts[0].substring(2)}';
          } else {
            // DD-MM-YYYY → DD-MM-YY
            return '${parts[0]}-${parts[1]}-${parts[2].substring(2)}';
          }
        }
      }
      // DD/MM/YYYY
      if (raw.contains('/')) {
        final parts = raw.split('/');
        if (parts.length == 3) {
          return '${parts[0]}-${parts[1]}-${parts[2].substring(2)}';
        }
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
