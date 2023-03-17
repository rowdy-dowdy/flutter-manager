import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:manager/components/bottom_navbar.dart';
import 'package:manager/components/logo.dart';
import 'package:manager/pages/home/_appbar.dart';
import 'package:manager/pages/home/_body_list_all.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: const HomeAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("Tất cả", style: TextStyle(fontWeight: FontWeight.w600),),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("Sử dụng", style: TextStyle(fontWeight: FontWeight.w600),),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("Còn trống", style: TextStyle(fontWeight: FontWeight.w600),),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: const [
                  BodyListAll(),
                  Center(child: Text("Group")),
                  Center(child: Text("Group")),
                ],
              ),
            ),
          ],
        )
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}