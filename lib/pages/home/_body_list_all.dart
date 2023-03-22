import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/models/Floor.dart';
import 'package:manager/models/RoomModel.dart';
import 'package:manager/repositories/FloorRepository.dart';
import 'package:manager/utils/color.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final listFloorProvider = FutureProvider((ref) async {
  final floor = ref.read(floorRepositoryProvider);
  var _items = await floor.getListFloor();
  return  Future.value(_items);
});

final floorStatusProvider = StateProvider((ref) {
  return "";
});

final filterProvider = Provider((ref) {
  List<FloorModel> floors = ref.watch(listFloorProvider).whenData((value) => value).value ?? [];
  final filter = ref.watch(floorStatusProvider);
  if (filter == "") return floors.fold<List<RoomModel>>([],(t, e) => t + e.rooms);
  return floors.singleWhere((floor) => floor.id == filter).rooms;
});

class BodyListAll extends ConsumerWidget {
  const BodyListAll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floors = ref.watch(listFloorProvider);
    final rooms = ref.watch(filterProvider);

    return Container(
      color: Colors.grey[100],
      // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(listFloorProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: floors.when(
            skipLoadingOnRefresh: false,
            data: (data) {
              return Column(
                children: [
                  const SizedBox(height: 10,),
                  SizedBox(
                    height: 34,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          onTap: () => ref.read(floorStatusProvider.notifier).state = data[i].id,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                            margin: EdgeInsets.only(
                              left: i == 0 ? 15 : 5,
                              right: i == data.length - 1 ? 15 : 5
                            ),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: primary2,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            alignment: Alignment.center,
                            child: Text("Tầng ${i+1}", style: const TextStyle(color: Colors.white),),
                          ),
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: AlignedGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      crossAxisCount: 2,
                      itemCount: rooms.length,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, item) {
                        var room = rooms[item];

                        return InkWell(
                          onTap: () => room.status == RoomStatus.empty ? context.go('/room/${room.id}/edit') : context.go('/room/${room.id}'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            constraints: const BoxConstraints(minHeight: 100),
                            decoration: BoxDecoration(
                              color: room.status != RoomStatus.empty ? primary2.withOpacity(.2) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: room.status != RoomStatus.empty ? primary2 : Colors.grey[300]!)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(room.title, style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16
                                ),),

                                if (room.status != RoomStatus.empty) ...[
                                  const SizedBox(height: 10,),
                                  Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: yellow2),
                                        // alignment: Alignment.center,
                                        child: const Icon(CupertinoIcons.money_dollar_circle_fill, size: 18, color: Colors.white,),
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: yellow2),
                                        // alignment: Alignment.center,
                                        child: const Icon(Icons.fastfood_outlined, size: 18, color: Colors.white,),
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: blue2),
                                        // alignment: Alignment.center,
                                        child: const Icon(CupertinoIcons.hare_fill, size: 18, color: Colors.white,),
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: blue2),
                                        // alignment: Alignment.center,
                                        child: const Icon(CupertinoIcons.calendar, size: 18, color: Colors.white,),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10,), 
                                  Text("1 Giờ 40 phút", style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13
                                  ),),
                                  const SizedBox(height: 10,),
                                  Text("888.000 ₫", style: TextStyle(
                                    color: blue2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),)
                                ],
                              ],
                            ),
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
          )
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
            child: AlignedGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              crossAxisCount: 2,
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