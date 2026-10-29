import 'package:flutter/material.dart';

class KartuInfo extends StatelessWidget {
  final String judul;
  final String isi;
  final IconData ikon;

  const KartuInfo({
    super.key,
    required this.judul,
    required this.isi,
    required this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          ikon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(judul),
        subtitle: Text(isi),
      ),
    );
  }
}