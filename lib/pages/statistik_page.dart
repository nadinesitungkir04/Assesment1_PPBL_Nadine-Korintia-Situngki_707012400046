
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/prediksi_provider.dart';

class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrediksiProvider>(
      builder: (context, provider, child) {
        final riwayat = provider.riwayat;
        final jumlahPetak = provider.jumlahPerPetak;
        final jumlahStatus = provider.jumlahPerStatus;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Statistik Mikroklimat',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ringkasan hasil prediksi pada lahan '
                'Kelompok Tani Sri Mulya.',
              ),
              const SizedBox(height: 20),

              // Statistik utama
              Row(
                children: [
                  Expanded(
                    child: _KartuStatistik(
                      judul: 'Total Prediksi',
                      nilai: '${provider.total}',
                      ikon: Icons.analytics_outlined,
                      warna: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KartuStatistik(
                      judul: 'Suhu Rata-rata',
                      nilai: riwayat.isEmpty
                          ? '-'
                          : '${provider.rataSuhu.toStringAsFixed(1)} °C',
                      ikon: Icons.thermostat,
                      warna: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Prediksi per Petak',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _KartuStatistik(
                judul: 'Petak 1',
                nilai: '${jumlahPetak['Petak 1'] ?? 0} prediksi',
                ikon: Icons.grass,
                warna: Colors.green,
              ),
              const SizedBox(height: 10),
              _KartuStatistik(
                judul: 'Petak 2',
                nilai: '${jumlahPetak['Petak 2'] ?? 0} prediksi',
                ikon: Icons.agriculture,
                warna: Colors.teal,
              ),

              const SizedBox(height: 24),

              const Text(
                'Kondisi Mikroklimat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _KartuStatistik(
                judul: 'Optimal',
                nilai: '${jumlahStatus['Optimal'] ?? 0} data',
                ikon: Icons.check_circle_outline,
                warna: Colors.green,
              ),
              const SizedBox(height: 10),
              _KartuStatistik(
                judul: 'Kering',
                nilai: '${jumlahStatus['Kering'] ?? 0} data',
                ikon: Icons.water_drop_outlined,
                warna: Colors.orange,
              ),
              const SizedBox(height: 10),
              _KartuStatistik(
                judul: 'Terlalu Lembap',
                nilai: '${jumlahStatus['Terlalu Lembap'] ?? 0} data',
                ikon: Icons.water,
                warna: Colors.blue,
              ),

              const SizedBox(height: 24),

              const Text(
                'Riwayat Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (riwayat.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text('Belum ada data prediksi.'),
                      ],
                    ),
                  ),
                )
              else
                ...riwayat.take(5).map((prediksi) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            prediksi.warnaStatus.withValues(alpha: 0.15),
                        child: Icon(
                          prediksi.ikonStatus,
                          color: prediksi.warnaStatus,
                        ),
                      ),
                      title: Text(
                        '${prediksi.tanaman} - ${prediksi.petak}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Suhu: ${prediksi.suhuUdara.toStringAsFixed(1)} °C\n'
                        'Kelembapan tanah: '
                        '${prediksi.kelembapanTanah.toStringAsFixed(1)}%',
                      ),
                      trailing: Text(
                        prediksi.status,
                        style: TextStyle(
                          color: prediksi.warnaStatus,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _KartuStatistik extends StatelessWidget {
  final String judul;
  final String nilai;
  final IconData ikon;
  final Color warna;

  const _KartuStatistik({
    required this.judul,
    required this.nilai,
    required this.ikon,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: warna.withValues(alpha: 0.15),
              child: Icon(ikon, color: warna),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nilai,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
