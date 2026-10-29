import 'package:flutter/material.dart';

class PengaturanPage extends StatelessWidget {
  final bool modeGelap;
  final ValueChanged<bool> onUbahTema;

  const PengaturanPage({
    super.key,
    required this.modeGelap,
    required this.onUbahTema,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Pengaturan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SwitchListTile(
          title: const Text('Mode gelap'),
          value: modeGelap,
          onChanged: onUbahTema,
        ),
      ],
    );
  }
}