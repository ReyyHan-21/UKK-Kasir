import 'package:flutter/material.dart';
import 'package:pl2_kasir/pages/admin/dashboard.dart';
import 'package:pl2_kasir/pages/component/appbar.dart';
import 'package:pl2_kasir/pages/list_item.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Indeks aktif
        onTap: _onItemTapped, // Fungsi yang dipanggil saat item diklik
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_rounded),
            label: 'List Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
