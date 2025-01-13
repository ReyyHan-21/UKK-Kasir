import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> createSeederAccount() async {
  final supabase = SupabaseClient(
    'https://oqggnqwundnnrszymrcw.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xZ2ducXd1bmRubnJzenltcmN3Iiwicm9sZSIsImlhdCI6MTczNjEyNzkwMywiZXhwIjoyMDUxNzAzOTAzfQ.lILs-KTsQxzSotoX8zJ68FJrMDoyaxgsBQLtbzp23YM',
  );

  try {
    // Mendapatkan daftar pengguna
    final response = await supabase.auth.admin.listUsers();

    // Cek apakah response valid
    if (response != null && response.isNotEmpty) {
      // Periksa apakah email 'administrator@gmail.com' sudah ada
      final userExists =
          response.any((user) => user.email == 'administrator@gmail.com');

      if (!userExists) {
        // Jika email tidak ada, buat akun baru
        final createResponse = await supabase.auth.admin.createUser(
          AdminUserAttributes(
            email: 'administrator@gmail.com',
            password: 'admin123',
            userMetadata: {
              'name': 'Administrator',
              'role': 'administrator',
            },
            emailConfirm: true,
          ),
        );

        if (createResponse.user != null) {
          print('Akun administrator berhasil dibuat.');
        } else {
          print('Error saat membuat akun: $e');
        }
      } else {
        print('User dengan email administrator@gmail.com sudah ada.');
      }
    } else {
      print('Gagal mendapatkan data pengguna.');
    }
  } catch (e) {
    print('Terjadi kesalahan: $e');
  }
}
