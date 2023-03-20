import 'dart:convert';
import 'package:manager/models/MenuModel.dart';

class MenuCategoryModel {
  final String id;
  final String title;
  final DateTime created;
  final DateTime updated;
  final List<MenuModel> menus;

  MenuCategoryModel({
    required this.id,
    required this.title,
    required this.created,
    required this.updated,
    required this.menus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
      'expand': {
        'menus(category)': menus.map((x) => x.toMap()).toList(),
      }
    };
  }

  factory MenuCategoryModel.fromMap(Map<String, dynamic> map) {
    return MenuCategoryModel(
      id: map['id'] as String,
      title: map['title'] as String,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
      menus: map['expand']?['menus(category)'] != null ? List<MenuModel>.from((map['expand']['menus(category)'] as List<dynamic>).map<MenuModel>((x) => MenuModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuCategoryModel.fromJson(String source) => MenuCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
