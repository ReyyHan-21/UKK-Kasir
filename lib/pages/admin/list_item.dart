import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListItem extends StatefulWidget {
  final Map<String, dynamic> product;

  const ListItem({Key? key, required this.product}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  // Add Data To Supabase
  final List<Map<String, dynamic>> products = [];
  late TextEditingController nameController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController stockController = TextEditingController();

  // Edit Data
  final _formKey = GlobalKey<FormState>();
  // late TextEditingController _nameController;
  // late TextEditingController _priceController;
  // late TextEditingController _stockController;

  final SupabaseClient supabase = Supabase.instance.client;

  // Fungsi untuk mengambil data dari Supabase
  Future<void> fetchProducts() async {
    try {
      final List<dynamic> response = await supabase.from('product').select();

      setState(() {
        products.clear();
        products.addAll(response.map((product) {
          return {
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

  // Fungsi untuk edit barang
  Future<void> editProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text;
    final price = priceController.text;
    final stock = stockController.text;

    final response = await Supabase.instance.client
        .from('product')
        .update({
          'name': name,
          'price': price,
          'stock': stock,
        })
        .eq('product_id', widget.product['product_id'])
        .select();

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erorr Kang'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil Kang'),
        ),
      );
      Navigator.pop(
        context,
        true,
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['nama_product']);
    priceController = TextEditingController(text: widget.product['harga']);
    stockController = TextEditingController(text: widget.product['stock']);

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
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.coffee),
                        title: Text(products[index]['name'] ?? 'Nama Produk'),
                        subtitle: Text(
                          'Harga: ${products[index]['price']} || Stok: ${products[index]['stock']}',
                        ),
                        trailing: IconButton(
                          onPressed: showEditDialog,
                          icon: const Icon(Icons.edit),
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

  void showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Barang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  icon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the field';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga Produk',
                  icon: Icon(Icons.price_change),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the field';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(
                  labelText: 'Stock Produk',
                  icon: Icon(Icons.production_quantity_limits),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the field';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: editProduct,
              child: const Text('Simpan'),
            )
          ],
        );
      },
    );
  }
}
