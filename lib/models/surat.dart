class Ayat {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;

  Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) => Ayat(
    nomorAyat: (json['nomorAyat'] ?? 0) as int,
    teksArab: (json['teksArab'] ?? '') as String,
    teksLatin: (json['teksLatin'] ?? '') as String,
    teksIndonesia: (json['teksIndonesia'] ?? '') as String,
  );
}

class Surat {
  final int nomor;
  final String nama; // teks Arab
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final List<Ayat> ayat; // kosong pada endpoint daftar, terisi pada detail

  Surat({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    this.ayat = const [],
  });

  factory Surat.fromJson(Map<String, dynamic> json) => Surat(
    nomor: (json['nomor'] ?? 0) as int,
    nama: (json['nama'] ?? '') as String,
    namaLatin: (json['namaLatin'] ?? '') as String,
    jumlahAyat: (json['jumlahAyat'] ?? 0) as int,
    tempatTurun: (json['tempatTurun'] ?? '') as String,
    arti: (json['arti'] ?? '') as String,
    // Deskripsi dari API berisi tag HTML, dibersihkan agar rapi.
    deskripsi: _stripHtml((json['deskripsi'] ?? '') as String),
    ayat: (json['ayat'] as List<dynamic>? ?? [])
        .map((e) => Ayat.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  static String _stripHtml(String input) => input
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .trim();
}