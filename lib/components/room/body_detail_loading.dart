import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/utils/color.dart';
import 'package:shimmer/shimmer.dart';

class BodyDetailLoading extends ConsumerWidget {
  const BodyDetailLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: Column(
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
                    color: primary2,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  alignment: Alignment.center,
                  child: Center(child: Container(width: 50, height: 10, decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),),)
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
              itemCount: 5,
              itemBuilder: (context, index) {

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(25)
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
                                Container(width: 100, height: 15, decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primary
                                ),),
                                const SizedBox(width: 3,),
                              ],
                            ),
                            const SizedBox(height: 7,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(width: 50, height: 10, decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                  ),),
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
                                  child: Container(width: 50, height: 10, decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
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
      ),
    );
  }
}