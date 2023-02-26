// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Buy Me A Coffee")));
  }
}
