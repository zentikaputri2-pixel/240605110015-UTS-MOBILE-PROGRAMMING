import 'package:flutter/material.dart';
import '../models/surat.dart';
import '../services/quran_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = QuranService();
  late Future<List<Surat>> _future;

  String _query = '';
  String? _tempatFilter; // null = semua

  @override
  void initState() {
    super.initState();
    _future = _service.fetchDaftarSurat();
  }

  void _reload() => setState(() => _future = _service.fetchDaftarSurat());

  /// Pengolahan data: filter berdasarkan tempat turun + pencarian nama/arti/nomor.
  List<Surat> _applyFilter(List<Surat> all) {
    final q = _query.toLowerCase();
    return all.where((s) {
      final matchTempat = _tempatFilter == null || s.tempatTurun == _tempatFilter;
      final matchQuery = q.isEmpty ||
          s.namaLatin.toLowerCase().contains(q) ||
          s.arti.toLowerCase().contains(q) ||
          s.nomor.toString() == q;
      return matchTempat && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Qur\'an Digital'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Surat>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Tidak dapat memuat data.\nPeriksa koneksi internet.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          final all = snapshot.data ?? [];
          final tempatList = all.map((s) => s.tempatTurun).toSet().toList();
          final shown = _applyFilter(all);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v.trim()),
                  decoration: InputDecoration(
                    hintText: 'Cari nama surat, arti, atau nomor...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('Semua'),
                        selected: _tempatFilter == null,
                        onSelected: (_) => setState(() => _tempatFilter = null),
                      ),
                    ),
                    for (final t in tempatList)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(t),
                          selected: _tempatFilter == t,
                          onSelected: (_) => setState(() => _tempatFilter = t),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${shown.length} surat • ${shown.fold<int>(0, (a, s) => a + s.jumlahAyat)} ayat',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                child: shown.isEmpty
                    ? const Center(child: Text('Surat tidak ditemukan.'))
                    : RefreshIndicator(
                  onRefresh: () async {
                    _reload();
                    await _future.catchError((_) => <Surat>[]);
                  },
                  child: ListView.separated(
                    itemCount: shown.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) =>
                        _SuratTile(surat: shown[i]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SuratTile extends StatelessWidget {
  final Surat surat;
  const _SuratTile({required this.surat});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: primary.withAlpha(30),
        child: Text('${surat.nomor}',
            style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
      ),
      title: Text(surat.namaLatin,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${surat.arti} • ${surat.jumlahAyat} ayat • ${surat.tempatTurun}'),
      trailing: Text(
        surat.nama,
        style: TextStyle(fontSize: 22, color: primary),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(surat: surat)),
      ),
    );
  }
}