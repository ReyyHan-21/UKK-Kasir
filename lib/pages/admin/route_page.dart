import 'package:flutter/material.dart';
import 'package:pl2_kasir/pages/admin/dashboard.dart';
import 'package:pl2_kasir/pages/component/appbar.dart';
import 'package:pl2_kasir/pages/admin/list_item.dart';
import 'package:pl2_kasir/pages/component/botNavbar.dart';

class routePage extends StatefulWidget {
  const routePage({super.key});

  @override
  State<routePage> createState() => _routePageState();
}

class _routePageState extends State<routePage> {
  // Indeks halaman aktif
  int _selectedIndex = 0;

  // Daftar halaman
  final List<Widget> _pages = [
    const Dashboard(),
    const ListItem(),
    const Center(
      child: Text(
        'Account Page Content',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];

  // Fungsi untuk mengubah halaman
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppsBar(
          customIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
      ),
      body: _pages[_selectedIndex], // Menampilkan halaman sesuai indeks
      bottomNavigationBar: Botnavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
