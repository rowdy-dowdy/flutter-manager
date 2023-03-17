import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomsProvider = FutureProvider((ref) async {
  return ;
});

class BodyListAll extends ConsumerWidget {
  const BodyListAll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('data')
          ]
        ),
      ),
    );
  }
}