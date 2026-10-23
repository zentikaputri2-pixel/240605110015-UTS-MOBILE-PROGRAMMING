import 'package:flutter/material.dart';
import '../models/surat.dart';
import '../services/quran_service.dart';

class DetailPage extends StatefulWidget {
  final Surat surat; // data ringkas dari halaman daftar
  const DetailPage({super.key, required this.surat});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _service = QuranService();
  late Future<Surat> _future;
  bool _tampilkanLatin = true;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchDetailSurat(widget.surat.nomor);
  }

  void _reload() => setState(
          () => _future = _service.fetchDetailSurat(widget.surat.nomor));

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surat.namaLatin),
        actions: [
          IconButton(
            tooltip: 'Tampilkan/sembunyikan latin',
            icon: Icon(_tampilkanLatin
                ? Icons.text_fields
                : Icons.text_fields_outlined),
            onPressed: () => setState(() => _tampilkanLatin = !_tampilkanLatin),
          ),
        ],
      ),
      body: FutureBuilder<Surat>(
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
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Gagal memuat ayat.'),
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

          final surat = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                color: primary.withAlpha(25),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(surat.nama,
                          style: TextStyle(
                              fontSize: 32,
                              color: primary,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${surat.namaLatin} (${surat.arti})',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${surat.jumlahAyat} ayat • ${surat.tempatTurun}',
                          style: const TextStyle(color: Colors.black54)),
                      if (surat.deskripsi.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ExpansionTile(
                          title: const Text('Tentang surat ini'),
                          tilePadding: EdgeInsets.zero,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(surat.deskripsi),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final a in surat.ayat) _AyatCard(ayat: a, showLatin: _tampilkanLatin),
            ],
          );
        },
      ),
    );
  }
}

class _AyatCard extends StatelessWidget {
  final Ayat ayat;
  final bool showLatin;
  const _AyatCard({required this.ayat, required this.showLatin});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: primary.withAlpha(30),
              child: Text('${ayat.nomorAyat}',
                  style: TextStyle(fontSize: 12, color: primary)),
            ),
            const SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  ayat.teksArab,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 26, height: 2),
                ),
              ),
            ),
            if (showLatin) ...[
              const SizedBox(height: 8),
              Text(ayat.teksLatin,
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: primary)),
            ],
            const SizedBox(height: 8),
            Text(ayat.teksIndonesia),
          ],
        ),
      ),
    );
  }
}