import 'dart:convert';

import 'package:manager/models/RoomItemModel.dart';

enum RoomStatus {
  empty,
  booking,
  using;

  String toJson() => name;
  static RoomStatus fromJson(String json) => values.byName(json);
}

class RoomModel {
  final String id;
  final String title;
  final String floor;
  final RoomStatus status;
  final DateTime created;
  final DateTime updated;
  List<RoomItemModel> items;
  
  RoomModel({
    required this.id,
    required this.title,
    required this.floor,
    required this.status,
    required this.created,
    required this.updated,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'floor': floor,
      'created': created.toString(),
      'updated': updated.toString(),
      'status': status.toJson(),
      'expand': {
        'items': items.map((x) => x.toMap()).toList(),
      }
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as String,
      title: map['title'] as String,
      floor: map['floor'] as String,
      status: RoomStatus.fromJson(map['status'] as String),
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
      items: map['expand']?['items'] != null ? List<RoomItemModel>.from((map['expand']['items'] as List<dynamic>).map<RoomItemModel>((x) => RoomItemModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) => RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
