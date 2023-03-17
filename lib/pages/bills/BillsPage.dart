import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/components/bottom_navbar.dart';
import 'package:manager/pages/home/_appbar.dart';

class BillsPage extends ConsumerWidget {
  const BillsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Text('bills')
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}