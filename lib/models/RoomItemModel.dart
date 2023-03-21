// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:manager/models/MenuModel.dart';

class RoomItemModel {
  final String id;
  final MenuModel menu;
  int quantity;
  
  RoomItemModel({
    required this.id,
    required this.menu,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'expand': {
        'menu': menu.toMap(),
      },
      'quantity': quantity,
    };
  }

  factory RoomItemModel.fromMap(Map<String, dynamic> map) {
    return RoomItemModel(
      id: map['id'] as String,
      menu: MenuModel.fromMap(map['expand']['menu'] as Map<String,dynamic>),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomItemModel.fromJson(String source) => RoomItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
