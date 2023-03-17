import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/components/logo.dart';

class HomeAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final double height;
  const HomeAppBar({this.height = 60, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAppBarState();
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            const Logo(),
            Expanded(child: Container(),),
            const SizedBox(width: 10,),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                shape: BoxShape.circle
              ),
              alignment: Alignment.center,
              child: const Icon(CupertinoIcons.search)
            ),
            const SizedBox(width: 10,),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                shape: BoxShape.circle
              ),
              alignment: Alignment.center,
              child: const Icon(CupertinoIcons.bell)
            )
          ],
        ),
      ),
    );
  }
}