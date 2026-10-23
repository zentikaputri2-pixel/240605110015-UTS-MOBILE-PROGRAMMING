import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surat.dart';

class QuranService {
  static const String _baseUrl = 'https://equran.id/api/v2';
  static const Duration _timeout = Duration(seconds: 20);

  Future<dynamic> _getData(String path) async {
    final response =
    await http.get(Uri.parse('$_baseUrl$path')).timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (kode ${response.statusCode})');
    }
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    return body['data'];
  }

  /// GET /surat -> daftar 114 surat
  Future<List<Surat>> fetchDaftarSurat() async {
    final data = await _getData('/surat') as List<dynamic>;
    return data.map((e) => Surat.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GET /surat/{nomor} -> detail surat beserta seluruh ayat
  Future<Surat> fetchDetailSurat(int nomor) async {
    final data = await _getData('/surat/$nomor') as Map<String, dynamic>;
    return Surat.fromJson(data);
  }
}