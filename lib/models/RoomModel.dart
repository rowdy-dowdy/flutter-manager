// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:manager/models/RoomItemModel.dart';
import 'package:manager/utils/utils.dart';

enum RoomStatus {
  empty,
  booking,
  using;

  String toJson() => name;
  static RoomStatus fromJson(String json) => values.byName(json);
}

class RoomModel extends Equatable {
  final String id;
  final String title;
  final String floor;
  RoomStatus status;
  final DateTime created;
  final DateTime updated;
  final DateTime? startTime;
  List<RoomItemModel> items;
  
  RoomModel({
    required this.id,
    required this.title,
    required this.floor,
    required this.status,
    required this.created,
    required this.updated,
    required this.items,
    required this.startTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'floor': floor,
      'created': created.toString(),
      'start_time': startTime != null ? startTime.toString() : null,
      'updated': updated.toString(),
      'status': status.toJson(),
      'expand': {
        'items': items.map((x) => x.toMap()).toList(),
      },
      'items': items.map((x) => x.id).toList(),
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as String,
      title: map['title'] as String,
      floor: map['floor'] as String,
      status: RoomStatus.fromJson(map['status'] as String),
      created: DateTime.parse(map['created'] as String),
      startTime: (map['start_time'] != null && map['start_time'] != "") ? DateTime.parse(map['start_time'] as String) : null,
      updated: DateTime.parse(map['updated'] as String),
      items: map['expand']?['items'] != null ? List<RoomItemModel>.from((map['expand']['items'] as List<dynamic>).map<RoomItemModel>((x) => RoomItemModel.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) => RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      id,
      title,
      floor,
      status,
      created,
      updated,
      items,
    ];
  }

  String formatTime() {
    if (startTime == null) return "";
    return formatTimeToString(startTime!);
  }

  double getAllPrice() {
    double priceAll = 0;

    priceAll = items.fold(priceAll, (previousValue, element) => previousValue + element.menu.price * element.quantity);

    return priceAll;
  }

  int countItems() {
    int data = 0;

    data = items.fold(data, (previousValue, element) => previousValue + element.quantity);

    return data;
  }
}
