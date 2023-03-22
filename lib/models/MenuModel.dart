// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:manager/config/app.dart';

class MenuModel {
  final String collectionId;
  final String id;
  final String title;
  final String category;
  final String image;
  final String container;
  final String status;
  final double price;
  final DateTime created;
  final DateTime updated;
  
  MenuModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.created,
    required this.updated,
    required this.image,
    required this.collectionId,
    required this.container,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'image': image,
      'collectionId': collectionId,
      'container': container,
      'status': status,
      'price': price.toInt(),
      'created': created.toString(),
      'updated': updated.toString(),
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
      collectionId: map['collectionId'] as String,
      container: map['container'] as String,
      status: map['status'] as String,
      price: (map['price'] as int).toDouble(),
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) => MenuModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String getImage() {
    return "https://$BASE_URL/api/files/$collectionId/$id/$image";
  }

  String formatCurrency() {
    final currencyFormatter = NumberFormat.currency(locale: 'vi');
    return currencyFormatter.format(price);
  }
}
