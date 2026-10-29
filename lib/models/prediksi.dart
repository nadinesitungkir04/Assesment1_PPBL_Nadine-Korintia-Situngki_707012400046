
import 'package:flutter/material.dart';

class HasilPrediksi {
  final String petak;
  final String tanaman;
  final double suhuUdara;
  final double kelembapanUdara;
  final double kelembapanTanah;
  final String namaPetugas;
  final DateTime waktu;

  HasilPrediksi({
    required this.petak,
    required this.tanaman,
    required this.suhuUdara,
    required this.kelembapanUdara,
    required this.kelembapanTanah,
    required this.namaPetugas,
    required this.waktu,
  });

  String get status {
    if (kelembapanTanah < 40) return 'Kering';
    if (kelembapanTanah <= 70) return 'Optimal';
    return 'Terlalu Lembap';
  }

  String get rekomendasi {
    if (status == 'Kering') {
      return 'Segera lakukan penyiraman atau irigasi.';
    }
    if (status == 'Optimal') {
      return 'Pertahankan pola perawatan saat ini.';
    }
    return 'Kurangi penyiraman dan periksa drainase.';
  }

  Color get warnaStatus {
    switch (status) {
      case 'Kering':
        return Colors.orange;
      case 'Optimal':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  IconData get ikonStatus {
    switch (status) {
      case 'Kering':
        return Icons.warning_amber_rounded;
      case 'Optimal':
        return Icons.check_circle_outline;
      default:
        return Icons.water_drop;
    }
  }

  String get catatanPerawatan {
    switch (tanaman.toLowerCase()) {
      case 'padi':
        return 'Jaga genangan air 2–5 cm pada fase vegetatif '
            'dan keringkan lahan menjelang panen.';
      case 'jagung':
        return 'Siram saat tanah mulai kering dan hindari '
            'genangan di sekitar perakaran.';
      case 'cabai':
        return 'Gunakan mulsa untuk menjaga kelembapan tanah '
            'dan siram pada pagi atau sore hari.';
      default:
        return 'Belum ada catatan perawatan untuk tanaman ini.';
    }
  }
}
