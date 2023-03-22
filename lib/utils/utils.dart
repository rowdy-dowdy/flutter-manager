import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content))
  );
}


String formatCurrency(double price) {
  final currencyFormatter = NumberFormat.currency(locale: 'vi');
  return currencyFormatter.format(price);
}