
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/beranda_page.dart';
import 'pages/prediksi_page.dart';
import 'pages/statistik_page.dart';
import 'pages/pengaturan_page.dart';
import 'pages/tentang_page.dart';
import 'pages/input_prediksi_page.dart';
import 'state/prediksi_provider.dart';

class AppRoutes {
  static const beranda = '/';
  static const tentang = '/tentang';
  static const inputPrediksi = '/inputprediksi';
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PrediksiProvider(),
      child: const AgriClimaApp(),
    ),
  );
}

class AgriClimaApp extends StatefulWidget {
  const AgriClimaApp({super.key});

  @override
  State<AgriClimaApp> createState() => _AgriClimaAppState();
}

class _AgriClimaAppState extends State<AgriClimaApp> {
  bool modeGelap = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriClima LSTM',
      themeMode: modeGelap ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.beranda,
      routes: {
        AppRoutes.beranda: (_) => KerangkaNavigasi(
              modeGelap: modeGelap,
              onUbahTema: (nilai) {
                setState(() {
                  modeGelap = nilai;
                });
              },
            ),
        AppRoutes.tentang: (_) => const TentangPage(),
        AppRoutes.inputPrediksi: (_) => const InputPrediksiPage(),
      },
    );
  }
}

class KerangkaNavigasi extends StatefulWidget {
  final bool modeGelap;
  final ValueChanged<bool> onUbahTema;

  const KerangkaNavigasi({
    super.key,
    required this.modeGelap,
    required this.onUbahTema,
  });

  @override
  State<KerangkaNavigasi> createState() =>
      _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int tabAktif = 0;

  final List<String> namaTab = [
    'Beranda',
    'Prediksi',
    'Statistik',
    'Pengaturan',
  ];

  @override
  Widget build(BuildContext context) {
    final halaman = [
      BerandaPage(
        onTentang: () {
          Navigator.pushNamed(
            context,
            AppRoutes.tentang,
          );
        },
      ),
      const PrediksiPage(),
      const StatistikPage(),
      PengaturanPage(
        modeGelap: widget.modeGelap,
        onUbahTema: widget.onUbahTema,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('AgriClima - ${namaTab[tabAktif]}'),
      ),
      body: IndexedStack(
        index: tabAktif,
        children: halaman,
      ),
      floatingActionButton: tabAktif == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.inputPrediksi,
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Prediksi Baru'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabAktif,
        onDestinationSelected: (index) {
          setState(() {
            tabAktif = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Consumer<PrediksiProvider>(
              builder: (context, provider, child) {
                final jumlah = provider.perluTindakan;

                return Badge(
                  isLabelVisible: jumlah > 0,
                  label: Text('$jumlah'),
                  child: const Icon(Icons.edit_note),
                );
              },
            ),
            selectedIcon: Consumer<PrediksiProvider>(
              builder: (context, provider, child) {
                final jumlah = provider.perluTindakan;

                return Badge(
                  isLabelVisible: jumlah > 0,
                  label: Text('$jumlah'),
                  child: const Icon(Icons.edit_note),
                );
              },
            ),
            label: 'Prediksi',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
