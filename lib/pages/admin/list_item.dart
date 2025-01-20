import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pl2_kasir/pages/component/edit_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListItem extends StatefulWidget {
  final Map<String, dynamic> product;

  const ListItem({super.key, required this.product});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  // Add Data To Supabase
  final List<Map<String, dynamic>> product = [];
  late TextEditingController nameController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController stockController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  // Fungsi untuk mengambil data dari Supabase
  Future<void> fetchProducts() async {
    try {
      final response = await supabase.from('product').select();

      setState(() {
        product.clear();
        product.addAll((response as List<dynamic>).map((product) {
          return {
            'id': product['product_id'],
            'name': product['nama_product'],
            'price': product['harga'],
            'stock': product['stock'],
          };
        }).toList());
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil produk: $e')),
      );
    }
  }

  // Fungsi untuk menambah data ke Supabase
  Future<void> createProduct(String name, String price, String stock) async {
    try {
      await supabase.from('product').insert({
        'nama_product': name,
        'harga': price,
        'stock': stock,
      });

      await fetchProducts(); // Ambil ulang data setelah penambahan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambah produk: $e'),
        ),
      );
    }
  }

  // Fungsi untuk menghapus data dari Supabase
  Future<void> deleteProduct(int id) async {
    try {
      // Pastikan id bertipe int
      await supabase.from('product').delete().eq('product_id', id);

      // Refresh data setelah penghapusan
      await fetchProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil dihapus'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus produk: $e'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Ambil data saat pertama kali widget dimuat
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Coffee,',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF8A66F),
              ),
            ),
            Text(
              'Smell Good Flavour',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: product.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.coffee,
                          color: Color(0xFF4E342E),
                        ),
                        title: Text(
                          product[index]['name'] ?? 'Nama Produk',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(
                          'Harga: ${product[index]['price']} || Stok: ${product[index]['stock']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final updatedProduct =
                                    await showDialog<Map<String, dynamic>>(
                                  context: context,
                                  builder: (context) => EditProductDialog(
                                    product: product[index],
                                  ),
                                );
                                if (updatedProduct != null) {
                                  setState(() {
                                    product[index] = updatedProduct;
                                  });
                                  await fetchProducts(); // Refresh data setelah pengeditan
                                }
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                final int productId = int.parse(product[index]
                                        ['id']
                                    .toString()); // Konversi ke integer
                                showDeleteConfirmationDialog(productId);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 15,
                        endIndent: 15,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddProductDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

// Dialog input data baru
  void showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Produk Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  icon: Icon(Icons.label),
                ),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga Produk',
                  icon: Icon(Icons.price_change),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(
                  labelText: 'Stock Produk',
                  icon: Icon(Icons.production_quantity_limits),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final price = priceController.text;
                final stock = stockController.text;

                if (name.isNotEmpty && price.isNotEmpty && stock.isNotEmpty) {
                  createProduct(name, price, stock);
                  Navigator.of(context).pop();
                  nameController.clear();
                  priceController.clear();
                  stockController.clear();
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
      },
    );
  }

  // Delete Product
  void showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteProduct(id); // Pastikan id adalah integer
                Navigator.of(context).pop(); // Tutup dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna tombol hapus
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
