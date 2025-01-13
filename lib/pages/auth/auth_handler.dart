import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> AuthHandler(String email, String password) async {
  final supabase = SupabaseClient(
    'https://oqggnqwundnnrszymrcw.supabase.co', // URL proyek Anda
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xZ2ducXd1bmRubnJzenltcmN3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczNjEyNzkwMywiZXhwIjoyMDUxNzAzOTAzfQ.lILs-KTsQxzSotoX8zJ68FJrMDoyaxgsBQLtbzp23YM', // Public API Key
  );

  try {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Jika berhasil login, kembalikan true
    if (response.user != null) {
      return true;
    } else {
      // Gagal login, tangani sesuai kebutuhan
      return false;
    }
  } catch (e) {
    print('Kesalahan saat login: $e');
    return false;
  }
}
