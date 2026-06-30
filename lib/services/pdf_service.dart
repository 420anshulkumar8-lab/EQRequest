import 'dart:convert';
import 'package:http/http.dart' as http;

class PnrDetails {
  final String trainNo;
  final String trainName;
  final String doj;
  final String from;
  final String to;
  final String trainClass;
  final String currentStatus;
  final bool success;
  final String? error;

  PnrDetails({
    required this.trainNo,
    required this.trainName,
    required this.doj,
    required this.from,
    required this.to,
    required this.trainClass,
    required this.currentStatus,
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
        final root = json.decode(response.body);

        final isSuccess = root['success'] == true;
        if (!isSuccess) {
          return _empty('PNR not found. Please fill manually.');
        }

        final d = root['data'] as Map<String, dynamic>?;
        if (d == null) {
          return _empty('PNR not found. Please fill manually.');
        }

        final trainNo   = d['trainNumber']?.toString() ?? '';
        final trainName = d['trainName']?.toString() ?? '';
        final doj       = _formatDate(d['dateOfJourney']?.toString() ?? '');
        final from      = d['boardingPoint']?.toString() ??
                          d['sourceStation']?.toString() ?? '';
        final to        = d['reservationUpto']?.toString() ??
                          d['destinationStation']?.toString() ?? '';
        final cls       = d['journeyClass']?.toString() ?? '';
        final currentStatus = _extractCurrentStatus(d);

        if (trainNo.isNotEmpty) {
          return PnrDetails(
            trainNo: trainNo,
            trainName: trainName,
            doj: doj,
            from: from,
            to: to,
            trainClass: _mapClass(cls),
            currentStatus: currentStatus,
            success: true,
          );
        } else {
          return _empty('PNR not found. Please fill manually.');
        }
      } else if (response.statusCode == 429) {
        return _empty('API limit reached. Please fill manually.');
      } else {
        return _empty('Error ${response.statusCode}. Please fill manually.');
      }
    } catch (e) {
      return _empty('Network error. Please fill manually.');
    }
  }

  static String _extractCurrentStatus(Map<String, dynamic> d) {
    try {
      final list = d['passengerList'] as List?;
      if (list == null || list.isEmpty) return '';

      final p = list[0] as Map<String, dynamic>;

      final statusCode = p['currentStatusCode']?.toString() ?? '';
      final coach      = p['currentCoachId']?.toString() ?? '';
      final berth      = p['currentBerthNo']?.toString() ?? '';

      if (statusCode == 'CNF' && coach.isNotEmpty && berth.isNotEmpty) {
        return 'CNF/$coach/$berth';
      } else if (statusCode.isNotEmpty) {
        return statusCode;
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  static PnrDetails _empty(String error) => PnrDetails(
    trainNo: '', trainName: '', doj: '', from: '', to: '',
    trainClass: '', currentStatus: '', success: false, error: error,
  );

  static String _formatDate(String raw) {
    try {
      if (raw.isEmpty) return '';
      final months = {
        'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
        'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
        'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12',
      };
      final match = RegExp(r'([A-Za-z]{3})\s+(\d{1,2}),\s+(\d{4})').firstMatch(raw);
      if (match != null) {
        final mon  = months[match.group(1)] ?? '01';
        final day  = match.group(2)!.padLeft(2, '0');
        final year = match.group(3)!.substring(2);
        return '$day-$mon-$year';
      }
      if (raw.contains('-')) {
        final parts = raw.split('-');
        if (parts.length == 3) {
          if (parts[0].length == 4) {
            return '${parts[2]}-${parts[1]}-${parts[0].substring(2)}';
          } else {
            final y = parts[2].length > 2 ? parts[2].substring(2) : parts[2];
            return '${parts[0]}-${parts[1]}-$y';
          }
        }
      }
      if (raw.contains('/')) {
        final parts = raw.split('/');
        if (parts.length == 3) {
          final y = parts[2].length > 2 ? parts[2].substring(2) : parts[2];
          return '${parts[0]}-${parts[1]}-$y';
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
      '1A': '1AC', '2A': '2AC', '3A': '3AC', '3E': '3AC-E',
      'SL': 'SL',  'CC': 'CC',  'EC': 'ECC', 'ECC': 'ECC',
      '1AC': '1AC','2AC': '2AC','3AC': '3AC',
    };
    return classMap[r] ?? r;
  }
}