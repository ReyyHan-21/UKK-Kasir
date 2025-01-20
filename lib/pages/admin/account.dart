import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon instead of Image
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // User Name
            const Text(
              'Username',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // User Email
            const Text(
              'Role',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // Options List
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildListItem(
                  Icons.person,
                  'Tambahkan Petugas',
                  'Hanya Admin Yang Dapat Menambahkan Petugas',
                  Icons.add,
                ),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget Builder
  Widget _buildListItem(
    IconData icon,
    String title,
    String subtitle,
    IconData trailing,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF4E342E),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: Icon(trailing),
      onTap: () {
        // Add navigation or action here
      },
    );
  }
}
