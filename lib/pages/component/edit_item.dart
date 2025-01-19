import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProductDialog extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductDialog({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai produk yang sedang diedit
    nameController = TextEditingController(text: widget.product['name']);
    priceController =
        TextEditingController(text: widget.product['price'].toString());
    stockController =
        TextEditingController(text: widget.product['stock'].toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> updateProduct(
      String id, String name, String price, String stock) async {
    try {
      await supabase.from('product').update({
        'nama_product': name,
        'harga': price,
        'stock': stock,
      }).eq('product_id', id);

      // Kembalikan data produk yang diperbarui ke halaman sebelumnya
      Navigator.of(context).pop({
        'id': id,
        'name': name,
        'price': price,
        'stock': stock,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil diperbarui'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui produk: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Produk'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Produk',
              icon: Icon(Icons.folder),
            ),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(
              labelText: 'Harga Produk',
              icon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: stockController,
            decoration: const InputDecoration(
              labelText: 'Stock Produk',
              icon: Icon(Icons.shopping_cart),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text;
            final price = priceController.text;
            final stock = stockController.text;

            if (name.isNotEmpty && price.isNotEmpty && stock.isNotEmpty) {
              updateProduct(
                widget.product['id'].toString(),
                name,
                price,
                stock,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Isi semua bidang')),
              );
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
