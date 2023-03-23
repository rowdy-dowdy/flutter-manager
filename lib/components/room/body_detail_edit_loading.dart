import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/utils/color.dart';
import 'package:shimmer/shimmer.dart';

class BodyDetailEditLoading extends ConsumerWidget {
  const BodyDetailEditLoading({super.key});

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
}