import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:manager/utils/color.dart';
import 'package:timeago/timeago.dart' as timeago;

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content))
  );
}

String formatCurrency(double price) {
  final currencyFormatter = NumberFormat.currency(locale: 'vi', symbol: '₫');
  return currencyFormatter.format(price);
}

String formatTimeToString(DateTime time) {
  timeago.setLocaleMessages('vi', timeago.ViMessages());
  timeago.setLocaleMessages('vi_short', timeago.ViShortMessages());
  
  final now = DateTime.now();
  // time = DateTime.now().subtract(Duration(minutes: 15));
  final difference  = now.difference(time);
  return timeago.format(now.subtract(difference), locale: 'vi_short');
}

Future dialogEscape(BuildContext context, String title, String description) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Trở lại'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Buộc rời'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}

enum AlertEnum {
  success,
  warning,
  error
}

class AlertWidget extends ConsumerStatefulWidget {
  final AlertEnum type;
  const AlertWidget({required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends ConsumerState<AlertWidget> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  late String title = widget.type == AlertEnum.success ? "Tuyệt vời" : "Hỏng rồi";
  late String description = widget.type == AlertEnum.success 
    ? "Yêu cầu của bạn đã được xử lý thành công" 
    : "Yêu cầu của bạn không thành công, vui lòng thử lại sau";

  @override
  void initState() {
    super.initState();

    controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    scaleAnimation =
      CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  width: 250,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: widget.type == AlertEnum.success ? primary2 : yellow2
                  ),
                  alignment: Alignment.center,
                  child: const Icon(CupertinoIcons.check_mark_circled, color: Colors.white, size: 36,),
                ),
                Container(
                  width: 250,
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    color: Colors.white
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),),
                      const SizedBox(height: 7,),
                      Text(description, style: const TextStyle(
                        // fontSize: 14
                      ), textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}