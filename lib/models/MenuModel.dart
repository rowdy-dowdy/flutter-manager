// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MenuModel {
  final String id;
  final String title;
  final String category;
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
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'price': price,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      price: (map['price'] as int).toDouble(),
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) => MenuModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
