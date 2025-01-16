import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditBookPage extends StatefulWidget {
  final Map<String, dynamic> book; // Data buku yang akan diedit

  const EditBookPage({Key? key, required this.book}) : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi controller dengan nilai yang ada di widget.book
    _titleController = TextEditingController(text: widget.book['title']);
    _authorController = TextEditingController(text: widget.book['author']);
    _descriptionController =
        TextEditingController(text: widget.book['description']);
  }

  // Fungsi untuk mengupdate data buku ke Supabase
  Future<void> _updateBook() async {
    if (!_formKey.currentState!.validate()) {
      return; // Jika form tidak valid, hentikan proses
    }

    final title = _titleController.text;
    final author = _authorController.text;
    final description = _descriptionController.text;

    // Kirim data untuk update ke Supabase berdasarkan ID
    final response = await Supabase.instance.client
        .from('books')
        .update({
          'title': title,
          'author': author,
          'description': description,
        })
        .eq('id', widget.book['id']) // Update berdasarkan ID buku
        .select();

    // Menampilkan feedback kepada pengguna
    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error updating book')), // Error saat update
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Book updated successfully!')), // Berhasil update
      );
      Navigator.pop(
        context,
        true,
      ); // Kembali ke halaman sebelumnya setelah update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'), // Judul halaman
        centerTitle: true, // Menyusun judul di tengah
        backgroundColor: Colors.pink[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding di sekitar form
        child: Form(
          key: _formKey, // Kunci untuk validasi form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field untuk mengedit judul buku
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title', // Label untuk field
                  border: UnderlineInputBorder(), // Border bawah
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title'; // Validasi kosong
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10), // Jarak antar field
              // Field untuk mengedit penulis buku
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author'; // Validasi kosong
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10), // Jarak antar field
              // Field untuk mengedit deskripsi buku
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description'; // Validasi kosong
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40), // Jarak antar tombol
              // Tombol untuk menyimpan perubahan
              Center(
                child: ElevatedButton(
                  onPressed:
                      _updateBook, // Memanggil fungsi update saat tombol ditekan
                  child: const Text(
                    'Update Book',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
