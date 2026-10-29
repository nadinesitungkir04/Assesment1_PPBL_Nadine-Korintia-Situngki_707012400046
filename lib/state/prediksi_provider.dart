
import 'package:flutter/material.dart';
import '../models/prediksi.dart';

class PrediksiProvider extends ChangeNotifier {
  final List<HasilPrediksi> _riwayat = [];

  List<HasilPrediksi> get riwayat =>
      List.unmodifiable(_riwayat);

  void tambah(HasilPrediksi prediksi) {
    _riwayat.insert(0, prediksi);
    notifyListeners();
  }

  void hapus(int index) {
    if (index >= 0 && index < _riwayat.length) {
      _riwayat.removeAt(index);
      notifyListeners();
    }
  }

  void hapusSemua() {
    _riwayat.clear();
    notifyListeners();
  }

  int get total => _riwayat.length;

  int get optimal =>
      _riwayat.where((item) => item.status == 'Optimal').length;

  int get perluTindakan =>
      _riwayat.where((item) => item.status != 'Optimal').length;

  int get kering =>
      _riwayat.where((item) => item.status == 'Kering').length;

  int get terlaluLembap =>
      _riwayat.where((item) => item.status == 'Terlalu Lembap').length;

  double get rataSuhu {
    if (_riwayat.isEmpty) return 0;

    return _riwayat.fold<double>(
          0,
          (jumlah, item) => jumlah + item.suhuUdara,
        ) /
        _riwayat.length;
  }

  Map<String, int> get jumlahPerPetak {
    return {
      'Petak 1': _riwayat.where((p) => p.petak == 'Petak 1').length,
      'Petak 2': _riwayat.where((p) => p.petak == 'Petak 2').length,
    };
  }

  Map<String, int> get jumlahPerStatus {
    return {
      'Kering': kering,
      'Optimal': optimal,
      'Terlalu Lembap': terlaluLembap,
    };
  }
}
