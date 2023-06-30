// Impor library yang diperlukan
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Impor model Anggota
import '../../model/anggota.dart';

// Impor UI Sidebar
import '../partials/sidebar.dart';

// Buat Class AnggotaListPage untuk menampilkan halaman list anggota
class AnggotaListPage extends StatefulWidget {
  @override
  _AnggotaListPageState createState() => _AnggotaListPageState();
}

// Buat Class _AnggotaListPageState untuk membuat state dari AnggotaListPage
class _AnggotaListPageState extends State<AnggotaListPage> {

  // Deklarasi variabel untuk menampung data anggota
  List<Anggota> anggotaList = [];

  // Method untuk mengambil data anggota dari API
  Future<List<Anggota>> fetchAnggotaList() async {
    // Kirim request ke API
    final response = await http
        .get(Uri.parse('https://649443970da866a953677178.mockapi.io/anggota'));

    // Jika response sukses
    if (response.statusCode == 200) {
      // Ubah response body menjadi list
      final List<dynamic> responseData = json.decode(response.body);
      // Map response data ke model Anggota
      return responseData.map((data) => Anggota.fromJson(data)).toList();
    } else {
      // Jika response gagal, throw error
      throw Exception('Data anggota tidak dapat diambil');
    }
  }

  // Method untuk merefresh data anggota
  Future<void> refreshAnggotaList() async {
    // Fetch anggota list from API
    final List<Anggota> list = await fetchAnggotaList();
    // Set state untuk refresh UI
    setState(() {
      anggotaList = list;
    });
  }

  // Method untuk menghapus anggota
  Future<void> deleteAnggota(String id) async {
    // Kirim request ke API
    final response = await http.delete(
      Uri.parse('https://649443970da866a953677178.mockapi.io/anggota/$id'),
    );
    // Jika response sukses
    if (response.statusCode == 200) {
      setState(() {
        // Hapus anggota dari list
        anggotaList.removeWhere((anggota) => anggota.id == id);
      });
    } else {
      // Jika response gagal, throw error
      throw Exception('Gagal menghapus anggota');
    }
  }

  // Method untuk menambah anggota
  Future<void> addAnggota(String nama, int nim, String kelas) async {
    // Kirim request ke API
    final response = await http.post(
      Uri.parse('https://649443970da866a953677178.mockapi.io/anggota'),
      body: {
        'nama': nama,
        'nim': nim.toString(),
        'kelas': kelas,
      },
    );

    // Jika response sukses
    if (response.statusCode == 201) {
      // Ubah response body menjadi objek Anggota
      final responseData = json.decode(response.body);
      final newAnggota = Anggota.fromJson(responseData);
      // Tambahkan anggota ke database
      setState(() {
        anggotaList.add(newAnggota);
      });
    } else {
      throw Exception('Gagal menambah anggota');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAnggotaList().then((list) {
      setState(() {
        anggotaList = list;
      });
    });
  }

  // Buat UI untuk menampilkan list anggota
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Anggota'),
      ),
      drawer: Sidebar(),
      body: ListView.builder(
        itemCount: anggotaList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(anggotaList[index].nama),
              subtitle: Text(anggotaList[index].nim.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol Hapus
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Konfirmasi'),
                          content: Text(
                              'Apakah Anda yakin ingin menghapus anggota ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteAnggota(anggotaList[index].id);
                                Navigator.pop(context);
                              },
                              child: Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Tombol Detail
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnggotaDetailPage(
                            anggota: anggotaList[index],
                          ),
                        ),
                      );
                    },
                  ),
                  // Tombol Edit
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnggotaUpdatePage(
                            anggota: anggotaList[index],
                          ),
                        ),
                      ).then((value) {
                        if (value == true) {
                          fetchAnggotaList().then((list) {
                            setState(() {
                              anggotaList = list;
                            });
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Tombol tambah anggota
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AnggotaAddPage()),
          ).then((value) {
            // Jika halaman tambah anggota ditutup, maka refresh list
            if (value != null && value is Map) {
              final String nama = value['nama'];
              final int nim = value['nim'];
              final String kelas = value['kelas'];
              addAnggota(nama, nim, kelas);
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Halaman untuk melihat detail anggota
class AnggotaDetailPage extends StatelessWidget {
  final Anggota anggota;

  AnggotaDetailPage({required this.anggota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Anggota'),
      ),
      drawer: Sidebar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Tampilkan data anggota
            Text('Nama: ${anggota.nama}'),
            Text('NIM: ${anggota.nim}'),
            Text('Kelas: ${anggota.kelas}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnggotaUpdatePage(anggota: anggota)),
          ).then((value) {
            if (value == true) {
              Navigator.pop(context, true);
            }
          });
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}

class AnggotaAddPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Anggota'),
      ),
      drawer: Sidebar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: nimController,
              decoration: InputDecoration(labelText: 'NIM'),
            ),
            TextField(
              controller: kelasController,
              decoration: InputDecoration(labelText: 'Kelas'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final String nama = namaController.text;
                final int nim = int.parse(nimController.text);
                final String kelas = kelasController.text;
                Navigator.pop(
                    context, {'nama': nama, 'nim': nim, 'kelas': kelas});
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnggotaUpdatePage extends StatelessWidget {
  final Anggota anggota;
  final TextEditingController namaController;
  final TextEditingController nimController;
  final TextEditingController kelasController;

  AnggotaUpdatePage({required this.anggota})
      : namaController = TextEditingController(text: anggota.nama),
        nimController = TextEditingController(text: anggota.nim.toString()),
        kelasController = TextEditingController(text: anggota.kelas);

  Future<void> updateAnggota(
      String id, String nama, int nim, String kelas) async {
    final response = await http.put(
      Uri.parse('https://649443970da866a953677178.mockapi.io/anggota/$id'),
      body: {
        'nama': nama,
        'nim': nim.toString(),
        'kelas': kelas,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update anggota');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Anggota'),
      ),
      drawer: Sidebar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: nimController,
              decoration: InputDecoration(labelText: 'NIM'),
            ),
            TextField(
              controller: kelasController,
              decoration: InputDecoration(labelText: 'Kelas'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final String nama = namaController.text;
                final int nim = int.parse(nimController.text);
                final String kelas = kelasController.text;
                updateAnggota(anggota.id, nama, nim, kelas).then((_) {
                  Navigator.pop(context, true);
                }).catchError((error) {
                  // Handle error jika gagal mengupdate anggota
                  print(error);
                });
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}



