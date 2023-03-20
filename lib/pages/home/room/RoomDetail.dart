// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/controllers/RoomController.dart';
import 'package:manager/models/MenuCategory.dart';
import 'package:manager/models/MenuModel.dart';
import 'package:manager/repositories/MenuRepository.dart';
import 'package:manager/utils/color.dart';
import 'package:shimmer/shimmer.dart';

final listMenuCategoryProvider = FutureProvider((ref) async {
  final data = ref.read(menuCategoryRepositoryProvider);
  return data.getListFloor();
  // return  Future.value(_items);
});

final menuCategoryStatusProvider = StateProvider((ref) {
  return "";
});

final filterProvider = Provider((ref) {
  List<MenuCategoryModel> data = ref.watch(listMenuCategoryProvider).whenData((value) => value).value ?? [];
  final filter = ref.watch(menuCategoryStatusProvider);
  if (filter == "") return data.fold<List<MenuModel>>([],(t, e) => t + e.menus);
  return data.singleWhere((floor) => floor.id == filter).menus ?? [];
});

class RoomDetail extends ConsumerWidget {
  final String id; 
  const RoomDetail({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final menuCategories = ref.watch(listMenuCategoryProvider);
    final menus = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(CupertinoIcons.xmark),
        ),
        title: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(roomProvider(id));
            if (state.loading) {
              return const Text("loading...");
            }
            else if (state.room == null) {
              return const Text("Không thể tải room");
            }
            else {
              return Text(state.room!.title);
            }
          },
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(listMenuCategoryProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: menuCategories.when(
            skipLoadingOnRefresh: false,
            data: (data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    height: 54,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length + 1,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int i) {
                        final status = ref.watch(menuCategoryStatusProvider);
                        return InkWell(
                          onTap: () => ref.read(menuCategoryStatusProvider.notifier).state = i == 0 ? "" : data[i - 1].id,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                            margin: EdgeInsets.only(
                              left: i == 0 ? 15 : 5,
                              right: i == data.length ? 15 : 5
                            ),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: (status == "" && i == 0) ? primary2 : (i > 0 && status == data[i - 1].id) ? primary2 : Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            alignment: Alignment.center,
                            child: Text(i == 0 ? "Tất cả" : data[i - 1].title, style: TextStyle(
                              color: (status == "" && i == 0) ? Colors.white : (i > 0 && status == data[i - 1].id) ? Colors.white : primary
                            ),),
                          ),
                        );
                      }
                    ),
                  ),
                  // const SizedBox(height: 15,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menus.length,
                      itemBuilder: (context, item) {
                        var menu = menus[item];
                        print(menu);

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]!))
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: primary2,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15,),
                ],
              );
            }, 
            error: (_, __) => const Center(child: Text("Không thể tải dữ liệu")), 
            loading: () => const BodyListLoading()
          ),
        ),
      ),
    );
  }
}

class BodyListLoading extends ConsumerWidget {
  const BodyListLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: Column(
        children: [
          const SizedBox(height: 10,),
          SizedBox(
            height: 34,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  margin: EdgeInsets.only(
                    left: i == 0 ? 15 : 5,
                    right: i == 4 ? 15 : 5
                  ),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  alignment: Alignment.center,
                  child: Text("Tầng ${i+1}", style: TextStyle(color: Colors.white),),
                );
              }
            ),
          ),
          const SizedBox(height: 15,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: MasonryGridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: 6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemBuilder: (context, item) {
                return Container(
                  constraints: const BoxConstraints(minHeight: 150),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(10)
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }
}