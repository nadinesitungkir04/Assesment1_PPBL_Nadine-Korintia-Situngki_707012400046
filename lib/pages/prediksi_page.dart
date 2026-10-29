
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/prediksi.dart';
import '../state/prediksi_provider.dart';

class PrediksiPage extends StatefulWidget {
  const PrediksiPage({super.key});

  @override
  State<PrediksiPage> createState() => _PrediksiPageState();
}

class _PrediksiPageState extends State<PrediksiPage> {
  String filterPetak = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Consumer<PrediksiProvider>(
      builder: (context, provider, child) {
        final semuaData = provider.riwayat;
        final data = filterPetak == 'Semua'
            ? semuaData
            : semuaData.where((p) => p.petak == filterPetak).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Riwayat Prediksi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              children: ['Semua', 'Petak 1', 'Petak 2'].map((petak) {
                return ChoiceChip(
                  label: Text(petak),
                  selected: filterPetak == petak,
                  onSelected: (_) {
                    setState(() => filterPetak = petak);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    judul: 'Total',
                    jumlah: data.length,
                    warna: Colors.blue,
                    ikon: Icons.analytics_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    judul: 'Optimal',
                    jumlah: data.where((p) => p.status == 'Optimal').length,
                    warna: Colors.green,
                    ikon: Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    judul: 'Perlu Tindakan',
                    jumlah: data.where((p) => p.status != 'Optimal').length,
                    warna: Colors.orange,
                    ikon: Icons.warning_amber_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              'Data Prediksi (${data.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (data.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.eco_outlined, size: 56, color: Colors.green),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada data',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Tekan tombol Prediksi Baru untuk menambahkan riwayat.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...data.map(
                (prediksi) => PrediksiCard(prediksi: prediksi),
              ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String judul;
  final int jumlah;
  final Color warna;
  final IconData ikon;

  const _StatCard({
    required this.judul,
    required this.jumlah,
    required this.warna,
    required this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Icon(ikon, color: warna, size: 25),
            const SizedBox(height: 8),
            Text(
              '$jumlah',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: warna,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              judul,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class PrediksiCard extends StatelessWidget {
  final HasilPrediksi prediksi;

  const PrediksiCard({super.key, required this.prediksi});

  @override
  Widget build(BuildContext context) {
    final warna = prediksi.warnaStatus;
    final kelembapan = prediksi.kelembapanTanah.clamp(0.0, 100.0);
    final waktu = prediksi.waktu;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(prediksi.ikonStatus, color: warna, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediksi.tanaman,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(prediksi.petak),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: warna.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      prediksi.status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: warna,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kelembapan tanah'),
                Text('${prediksi.kelembapanTanah.toStringAsFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: kelembapan / 100,
              minHeight: 9,
              borderRadius: BorderRadius.circular(8),
              color: warna,
              backgroundColor: warna.withOpacity(0.15),
            ),
            const SizedBox(height: 16),

            _detail(Icons.thermostat, 'Suhu udara',
                '${prediksi.suhuUdara.toStringAsFixed(1)} °C'),
            _detail(Icons.water_drop_outlined, 'Kelembapan udara',
                '${prediksi.kelembapanUdara.toStringAsFixed(1)}%'),
            _detail(Icons.person_outline, 'Nama petugas',
                prediksi.namaPetugas),

            const Divider(height: 24),
            const Text(
              'Rekomendasi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(prediksi.rekomendasi),
            const SizedBox(height: 12),

            const Text(
              'Catatan perawatan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(prediksi.catatanPerawatan),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.access_time, size: 17),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Waktu prediksi: ${waktu.day.toString().padLeft(2, '0')}/'
                    '${waktu.month.toString().padLeft(2, '0')}/${waktu.year} '
                    '${waktu.hour.toString().padLeft(2, '0')}:'
                    '${waktu.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(IconData ikon, String judul, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(ikon, size: 19, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(judul)),
          const SizedBox(width: 8),
          Text(nilai, textAlign: TextAlign.end),
        ],
      ),
    );
  }
}
