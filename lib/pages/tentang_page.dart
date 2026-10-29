import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    final informasi = [
      'Tujuan: membantu pencatatan hasil prediksi mikroklimat.',
      'Lokasi pemantauan: Petak 1.',
      'Lokasi pemantauan: Petak 2.',
      'Parameter: suhu udara.',
      'Parameter: kelembapan udara.',
      'Parameter: kelembapan tanah.',
      'Teknologi: deep learning LSTM.',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang AgriClima')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: informasi.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(informasi[index]),
            ),
          );
        },
      ),
    );
  }
}