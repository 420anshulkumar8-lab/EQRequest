import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/eq_record.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(EqRecordAdapter());
  await Hive.openBox<EqRecord>('records');

  runApp(const EqRequestApp());
}

class EqRequestApp extends StatelessWidget {
  const EqRequestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EQ Request',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}
