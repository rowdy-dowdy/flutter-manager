// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:manager/models/RoomModel.dart';

class FloorModel {
  final String id;
  final String title;
  final bool status;
  final DateTime created;
  final DateTime updated;
  final List<RoomModel> rooms;

  FloorModel({
    required this.id,
    required this.title,
    required this.status,
    required this.created,
    required this.updated,
    required this.rooms,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'status': status,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
      'expand': {
        'rooms(floor)' : rooms.map((x) => x.toMap()).toList(),
      }
    };
  }

  factory FloorModel.fromMap(Map<String, dynamic> map) {
    return FloorModel(
      id: map['id'] as String,
      title: map['title'] as String,
      status: map['status'] as bool,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
      rooms: map['expand']['rooms(floor)'] ? List<RoomModel>.from((map['expand']['rooms(floor)'] as List<dynamic>).map<RoomModel>((x) => RoomModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory FloorModel.fromJson(String source) => FloorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
