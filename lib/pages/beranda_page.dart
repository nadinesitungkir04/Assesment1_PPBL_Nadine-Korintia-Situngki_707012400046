import 'package:flutter/material.dart';
import '../widgets/kartu_info.dart';

class BerandaPage extends StatelessWidget {
  final VoidCallback onTentang;

  const BerandaPage({
    super.key,
    required this.onTentang,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Selamat Datang di AgriClima LSTM',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Aplikasi pencatatan prediksi mikroklimat '
          'Kelompok Tani Sri Mulya, Kabupaten Garut.',
        ),
        const SizedBox(height: 16),
        const KartuInfo(
          judul: 'Model Deep Learning',
          isi: 'Long Short-Term Memory (LSTM)',
          ikon: Icons.memory,
        ),
        const KartuInfo(
          judul: 'Periode Prediksi',
          isi: '24 jam ke depan',
          ikon: Icons.access_time,
        ),
        const KartuInfo(
          judul: 'Parameter Mikroklimat',
          isi: 'Suhu udara, kelembapan udara, kelembapan tanah',
          ikon: Icons.thermostat,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onTentang,
          child: const Text('Tentang Aplikasi'),
        ),
      ],
    );
  }
}