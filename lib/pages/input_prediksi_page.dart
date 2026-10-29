
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/prediksi.dart';
import '../state/prediksi_provider.dart';

class InputPrediksiPage extends StatefulWidget {
  const InputPrediksiPage({super.key});

  @override
  State<InputPrediksiPage> createState() => _InputPrediksiPageState();
}

class _InputPrediksiPageState extends State<InputPrediksiPage> {
  final formKey = GlobalKey<FormState>();
  final suhuController = TextEditingController();
  final udaraController = TextEditingController();
  final tanahController = TextEditingController();
  final petugasController = TextEditingController();

  String petak = 'Petak 1';
  String tanaman = 'Padi';
  bool dataBenar = false;

  @override
  void dispose() {
    suhuController.dispose();
    udaraController.dispose();
    tanahController.dispose();
    petugasController.dispose();
    super.dispose();
  }

  double? parseAngka(String nilai) =>
      double.tryParse(nilai.trim().replaceAll(',', '.'));

  String? validasiAngka(String? nilai) {
    if (nilai == null || nilai.trim().isEmpty) {
      return 'Wajib diisi';
    }

    final angka = parseAngka(nilai);
    if (angka == null || !angka.isFinite) {
      return 'Masukkan angka yang valid';
    }

    return null;
  }

  String? validasiPersen(String? nilai) {
    final error = validasiAngka(nilai);
    if (error != null) return error;

    final angka = parseAngka(nilai!)!;
    if (angka < 0 || angka > 100) {
      return 'Masukkan nilai 0 sampai 100';
    }

    return null;
  }

  Future<void> simpan() async {
    if (!formKey.currentState!.validate() || !dataBenar) return;

    final hasil = HasilPrediksi(
      petak: petak,
      tanaman: tanaman,
      suhuUdara: parseAngka(suhuController.text)!,
      kelembapanUdara: parseAngka(udaraController.text)!,
      kelembapanTanah: parseAngka(tanahController.text)!,
      namaPetugas: petugasController.text.trim(),
      waktu: DateTime.now(),
    );

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Penyimpanan'),
        content: Text(
          'Simpan prediksi tanaman $tanaman di $petak '
          'dengan status ${hasil.status}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );

    if (!mounted || konfirmasi != true) return;

    context.read<PrediksiProvider>().tambah(hasil);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data prediksi berhasil disimpan'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Prediksi')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Form Hasil Prediksi LSTM',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const Text(
              'Pilih Petak',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioGroup<String>(
              groupValue: petak,
              onChanged: (nilai) {
                if (nilai != null) setState(() => petak = nilai);
              },
              child: const Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Petak 1'),
                    value: 'Petak 1',
                  ),
                  RadioListTile<String>(
                    title: Text('Petak 2'),
                    value: 'Petak 2',
                  ),
                ],
              ),
            ),

            DropdownButtonFormField<String>(
              initialValue: tanaman,
              decoration: const InputDecoration(
                labelText: 'Nama Tanaman',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.grass),
              ),
              items: ['Padi', 'Jagung', 'Cabai']
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (nilai) {
                if (nilai != null) setState(() => tanaman = nilai);
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: suhuController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Prediksi Suhu Udara (°C)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.thermostat),
              ),
              validator: validasiAngka,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: udaraController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Prediksi Kelembapan Udara (%)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.water_drop_outlined),
              ),
              validator: validasiPersen,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: tanahController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Prediksi Kelembapan Tanah (%)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.grass),
              ),
              validator: validasiPersen,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: petugasController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nama Petugas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (nilai) =>
                  nilai == null || nilai.trim().isEmpty
                      ? 'Nama petugas wajib diisi'
                      : null,
            ),
            const SizedBox(height: 12),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Data sudah benar'),
              value: dataBenar,
              onChanged: (nilai) {
                setState(() => dataBenar = nilai ?? false);
              },
            ),
            const SizedBox(height: 16),

            FilledButton.icon(
              onPressed: dataBenar ? simpan : null,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
