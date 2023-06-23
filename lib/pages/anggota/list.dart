import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/anggota.dart';
import '../partials/sidebar.dart';

class AnggotaListPage extends StatefulWidget {
  @override
  _AnggotaListPageState createState() => _AnggotaListPageState();
}

class _AnggotaListPageState extends State<AnggotaListPage> {
  List<Anggota> anggotaList = [];

  Future<List<Anggota>> fetchAnggotaList() async {
    final response = await http
        .get(Uri.parse('https://649443970da866a953677178.mockapi.io/anggota'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => Anggota.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch anggota list');
    }
  }

  Future<void> refreshAnggotaList() async {
    // Fetch anggota list from API
    final List<Anggota> list = await fetchAnggotaList();
    setState(() {
      anggotaList = list;
    });
  }

  Future<void> deleteAnggota(String id) async {
    final response = await http.delete(
      Uri.parse('https://649443970da866a953677178.mockapi.io/anggota/$id'),
    );
    if (response.statusCode == 200) {
      setState(() {
        anggotaList.removeWhere((anggota) => anggota.id == id);
      });
    } else {
      throw Exception('Failed to delete anggota');
    }
  }

  Future<void> addAnggota(String nama, int nim, String kelas) async {
    final response = await http.post(
      Uri.parse('https://649443970da866a953677178.mockapi.io/anggota'),
      body: {
        'nama': nama,
        'nim': nim.toString(),
        'kelas': kelas,
      },
    );
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newAnggota = Anggota.fromJson(responseData);
      setState(() {
        anggotaList.add(newAnggota);
      });
    } else {
      throw Exception('Failed to add anggota');
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AnggotaAddPage()),
          ).then((value) {
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



