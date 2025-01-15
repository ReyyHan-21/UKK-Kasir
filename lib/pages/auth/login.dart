import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pl2_kasir/pages/admin/route_page.dart';
import 'package:pl2_kasir/pages/auth/auth_handler.dart'; // Pastikan kelas ini sudah benar

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObsecured = true;

  Future _handleCreateAdmin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi jika email dan password kosong
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Email dan password tidak boleh kosong');
      return;
    }

    try {
      final isSuccess = await AuthHandler(email, password);

      // Cek jika login berhasil
      if (isSuccess) {
        // Lakukan navigasi ke halaman berikutnya setelah login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const routePage()),
        );
      } else {
        // Menangani kondisi jika email atau password salah
        _showErrorDialog('Login gagal, periksa email dan password');
      }
    } catch (e) {
      // Tangani kesalahan lain yang mungkin terjadi saat login
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Image(image: AssetImage('auth.png')),
            const SizedBox(height: 10),
            Text(
              'Selamat Datang',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              text: TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: 'di ',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFF8A66F),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Halaman Login ',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Kasir Sederhana',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFF8A66F),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                label: Text(
                  'Username',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4E342E)),
                ),
                prefixIcon: const Icon(
                  Icons.person_rounded,
                  size: 32,
                  color: Color(0xFF4E342E),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                label: Text(
                  'Password',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4E342E)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObsecured ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObsecured = !_isObsecured;
                    });
                  },
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  size: 32,
                  color: Color(0xFF4E342E),
                ),
              ),
              obscureText: _isObsecured,
            ),
            const SizedBox(height: 45),
            ElevatedButton(
              onPressed: _handleCreateAdmin,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF4E342E),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Masuk',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
