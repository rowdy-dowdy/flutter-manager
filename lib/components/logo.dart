import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logo extends ConsumerWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const FlutterLogo(size: 30,),
        const SizedBox(width: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Việt Hùng IT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
            SizedBox(height: 2,),
            Text('Developer . Transporter', style: TextStyle(
              fontSize: 10,
              color: Colors.grey
            ),),
          ],
        )
      ],
    );
  }
}