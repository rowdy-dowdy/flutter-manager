// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:manager/components/room/body_detail_loading.dart';
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

class RoomDetail extends ConsumerWidget {
  final String id; 
  const RoomDetail({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // final menuCategories = ref.watch(listMenuCategoryProvider);
    // final menus = ref.watch(filterProvider);
    final state = ref.watch(roomProvider(id));

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
          )
        ),
        leading: IconButton(
          onPressed: () {
            ref.read(roomProvider(id).notifier).refresh();
            context.go('/');
          },
          icon: const Icon(CupertinoIcons.xmark),
        ),
        title: Consumer(
          builder: (context, ref, child) {
            // final state = ref.watch(roomProvider(id));
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
        actions: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: const Icon(Icons.more_vert),
                items: [
                  DropdownMenuItem(
                    onTap: () {},
                    value: "delete",
                    child: Row(
                      children: const [
                        Icon(CupertinoIcons.delete, size: 20,),
                        SizedBox(width: 5,),
                        Text("Hủy đơn hàng", style: TextStyle(
                          // color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                        ),),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  
                },
                dropdownStyleData: DropdownStyleData(
                  width: 160,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    // color: Colors.redAccent,
                  ),
                  elevation: 8,
                  offset: const Offset(0, 8),
                ),
                menuItemStyleData: MenuItemStyleData(
                  customHeights: [30],
                  padding: const EdgeInsets.only(left: 16, right: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5,)
        ],
      ),
      body: SingleChildScrollView(
        // physics: const AlwaysScrollableScrollPhysics(),
        child: Consumer(
          builder: (context, ref, child) {
            // return const BodyDetailLoading();
            if (state.loading) {
              return const BodyDetailLoading();
            }
            else if (state.room == null) {
              return const Center(child: Text("Không thể tải dữ liệu"));
            }
            else {
              final room = state.room;
              if (room == null) return const Center(child: Text("Không thể tải dữ liệu"));

              final String statusTitle = room.status == RoomStatus.empty ? "Phòng trống"
                : room.status == RoomStatus.booking ? "Đã đặt trước" : "Đang sử dụng";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // list menu category
                  Container(
                    // color: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: room.status == RoomStatus.booking ? yellow2 : primary2,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          alignment: Alignment.center,
                          child: Text(statusTitle, style: const TextStyle(
                            color: Colors.white
                          ),)
                        ),
                      ],
                    )
                  ),

                  // list item
                  Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: room.items.length,
                      itemBuilder: (context, index) {
                        var item = room.items[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CachedNetworkImage(
                                  imageUrl: item.menu.getImage(),
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
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(item.menu.title, style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ), maxLines: 2, overflow: TextOverflow.ellipsis),
                                        ),
                                        const SizedBox(width: 3,),
                                      ],
                                    ),
                                    const SizedBox(height: 7,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(formatCurrency(item.menu.price), style: const TextStyle(
                                            // fontWeight: FontWeight.w600,
                                          )),
                                        ),
                                        const SizedBox(width: 10,),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          constraints: const BoxConstraints(minWidth: 20),
                                          decoration: BoxDecoration(
                                            color: blue3,
                                            borderRadius: BorderRadius.circular(5)
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(item.quantity.toString(), style: const TextStyle(
                                            color: blue2, fontWeight: FontWeight.w500
                                          ),),
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
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        // height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
          child: Column(
            children: [
              Row(children: [
                Expanded(child: Row( children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Row(children: const [
                      Icon(CupertinoIcons.gift),
                      SizedBox(width: 3,),
                      Text("Khuyến mãi")
                    ],),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Row(children: const [
                      Icon(CupertinoIcons.person_3_fill),
                      SizedBox(width: 3,),
                      Text("0")
                    ],),
                  )
                ],)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text('Tổng tiền: ', style: TextStyle(fontWeight: FontWeight.w500),),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          constraints: const BoxConstraints(minWidth: 20),
                          decoration: BoxDecoration(
                            color: blue3,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          alignment: Alignment.center,
                          child: Text(state.room?.countItems().toString() ?? "0", style: const TextStyle(
                            color: blue2, fontWeight: FontWeight.w500
                          ),),
                        )
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Text(formatCurrency(state.room?.getAllPrice() ?? 0), style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 18
                    ),)
                  ],
                )
              ],),
              const SizedBox(height: 10,),
              Flexible(
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
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(5)
                          ),
                          alignment: Alignment.center,
                          child: const Text("Xem tạm tính", style: TextStyle(
                            color: Colors.white,
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
                          color: primary2,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        alignment: Alignment.center,
                        child: const Text("Thanh toán", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5,)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/room/$id/edit'),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}