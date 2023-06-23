class Anggota {
  final String id;
  final String nama;
  final String nim;
  final String kelas;

  Anggota(
      {required this.id,
      required this.nama,
      required this.nim,
      required this.kelas});

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'],
      nama: json['nama'],
      nim: json['nim'],
      kelas: json['kelas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'kelas': kelas,
    };
  }
}
