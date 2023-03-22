// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/controllers/RoomController.dart';
import 'package:manager/models/MenuCategory.dart';
import 'package:manager/models/MenuModel.dart';
import 'package:manager/models/RoomModel.dart';
import 'package:manager/repositories/MenuRepository.dart';
import 'package:manager/utils/color.dart';
import 'package:manager/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:collection/collection.dart';

final listMenuCategoryProvider = FutureProvider((ref) async {
  final data = ref.read(menuCategoryRepositoryProvider);
  return data.getList();
  // return  Future.value(_items);
});

final menuCategoryStatusProvider = StateProvider((ref) {
  return "";
});

final filterProvider = Provider((ref) {
  List<MenuCategoryModel> data = ref.watch(listMenuCategoryProvider).whenData((value) => value).value ?? [];
  final filter = ref.watch(menuCategoryStatusProvider);
  if (filter == "") return data.fold<List<MenuModel>>([],(t, e) => t + e.menus);
  return data.singleWhere((floor) => floor.id == filter).menus;
});

class RoomDetailEdit extends ConsumerWidget {
  final String id; 
  const RoomDetailEdit({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final menuCategories = ref.watch(listMenuCategoryProvider);
    final menus = ref.watch(filterProvider);
    final room = ref.watch(roomProvider(id)).room;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            ref.read(roomProvider(id).notifier).refresh();
            if (room?.status == RoomStatus.empty) {
              context.go('/');
            }
            else {
              context.go('/room/$id');
            }
          },
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
        actions: [IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search))],
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
                  // list menu category
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

                  // list item
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menus.length,
                      itemBuilder: (context, item) {
                        var menu = menus[item];
                        final roomItem = room?.items.singleWhereOrNull((element) => element.menu.id == menu.id);

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]!))
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [ 
                                  InkWell(
                                    onTap: () => ref.read(roomProvider(id).notifier).createRoomItem(menu),
                                    child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: CachedNetworkImage(
                                        imageUrl: menu.getImage(),
                                        imageBuilder: (context, imageProvider) => Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: imageProvider, fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  roomItem != null ? Positioned.fill(
                                    child: Container(
                                      color: Colors.white.withOpacity(.8),
                                      child: const Icon(CupertinoIcons.check_mark_circled_solid, color: blue2, size: 26,),
                                    ),
                                  ) : Container()
                                ],
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(menu.title, style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ), maxLines: 2, overflow: TextOverflow.ellipsis),
                                        ),
                                        const SizedBox(width: 3,),
                                        roomItem != null ? InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 25,
                                            decoration: BoxDecoration(color: Colors.grey[50]!),
                                            child: DropdownButton(
                                              icon: const Icon(Icons.more_vert),
                                              onChanged: (newValue) {},
                                              underline: const SizedBox(),
                                              items: [
                                                DropdownMenuItem(
                                                  onTap: () => ref.read(roomProvider(id).notifier).deleteRoomItem(roomItem.id),
                                                  value: 'delete',
                                                  child: const Text("Xóa lựa chọn", style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12
                                                  ),),
                                                ),
                                              ]
                                            )
                                          ),
                                        ) : Container(height: 25,)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        if (menu.status != "") ...[
                                          const Icon(Icons.circle, color: Colors.grey, size: 5,),
                                          Text("  ${menu.status}  ", style: const TextStyle(color: yellow2)),
                                          const Icon(Icons.circle, color: Colors.grey, size: 5,),
                                        ],
                                        Text("  ${menu.container}", style: const TextStyle(color: blue2)),
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(formatCurrency(menu.price), style: const TextStyle(fontSize: 14),),
                                        ),
                                        if (roomItem != null) ...[
                                          const SizedBox(width: 5,),
                                          InkWell(
                                            onTap: () {
                                              ref.read(roomProvider(id).notifier).changeQuantityRoomItem(roomItem.id, -1);
                                            },
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: blue2),
                                              child: const Icon(Icons.remove, size: 18, color: Colors.white,),
                                            ),
                                          ),
                                          const SizedBox(width: 15,),
                                          Text(roomItem.quantity.toString(), style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                          ),),
                                          const SizedBox(width: 15,),
                                          InkWell(
                                            onTap: () {
                                              ref.read(roomProvider(id).notifier).changeQuantityRoomItem(roomItem.id, 1);
                                            },
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: blue2),
                                              child: const Icon(Icons.add, size: 18, color: Colors.white,),
                                            ),
                                          )
                                        ],
                                      ],
                                    ),
                                  ],
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
      bottomNavigationBar: Container(
        width: double.infinity,
        // height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () => ref.read(roomProvider(id).notifier).refresh(),
                  child: Container(
                    width: double.infinity,
                    // height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(3)
                    ),
                    alignment: Alignment.center,
                    child: const Text("Chọn lại", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),textAlign: TextAlign.center,),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Flexible(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    color: yellow2,
                    borderRadius: BorderRadius.circular(3)
                  ),
                  alignment: Alignment.center,
                  child: const Text("Hẹn trước", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),textAlign: TextAlign.center,),
                ),
              ),
              const SizedBox(width: 10,),
              Flexible(
                child: Container(
                  width: double.infinity,
                  // height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    color: blue2,
                    borderRadius: BorderRadius.circular(3)
                  ),
                  alignment: Alignment.center,
                  child: Text((room?.items ?? []).isNotEmpty ? "Thêm vào đơn" : "Đặt bàn", style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),textAlign: TextAlign.center,),
                ),
              )
            ],
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
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, item) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.red
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Container(width: 150, height: 15, decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                                ),)),
                                const SizedBox(width: 5,),
                                const Icon(Icons.more_vert),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.circle, color: Colors.grey, size: 5,),
                                const SizedBox(width: 5,),
                                Container(width: 50, height: 15, decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                                ),),
                                const SizedBox(width: 5,),
                                const Icon(Icons.circle, color: Colors.grey, size: 5,),
                                const SizedBox(width: 5,),
                                Container(width: 50, height: 15, decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                                ),),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(width: 50, height: 15, decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.red
                                  ),),
                                ),
                                const SizedBox(width: 5,),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: blue2),
                                  child: const Icon(Icons.remove, size: 18, color: Colors.white,),
                                ),
                                const SizedBox(width: 15,),
                                Container(width: 10, height: 15, decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                                )),
                                const SizedBox(width: 15,),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: blue2),
                                  child: const Icon(Icons.add, size: 18, color: Colors.white,),
                                )
                              ],
                            ),
                          ],
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
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text('A dialog is a type of modal window that\n'
              'appears in front of app content to\n'
              'provide critical information, or prompt\n'
              'for a decision to be made.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}