import 'package:flutter/material.dart';

class AppsBar extends StatelessWidget {
  final Widget? customIcon; // Parameter opsional untuk ikon

  const AppsBar({Key? key, this.customIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('profile.jpg'),
          ),
          customIcon ?? // Gunakan customIcon jika ada, jika tidak gunakan ikon default
              IconButton(
                onPressed: () {
                  print("Default shopping cart pressed");
                },
                icon: const Icon(Icons.shopping_cart),
              ),
        ],
      ),
    );
  }
}
