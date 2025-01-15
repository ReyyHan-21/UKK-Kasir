import 'package:flutter/material.dart';
import 'package:pl2_kasir/pages/admin/route_page.dart';
import 'package:pl2_kasir/pages/auth/login.dart';
import 'package:pl2_kasir/pages/auth/seeder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://oqggnqwundnnrszymrcw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xZ2ducXd1bmRubnJzenltcmN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxMjc5MDMsImV4cCI6MjA1MTcwMzkwM30.UR-0Hw8qVKCdFRzPP55845C1p9m_Yr1P_MA8__APZCw',
  );
  await createSeederAccount();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: routePage(),
    );
  }
}
