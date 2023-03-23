// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:manager/config/app.dart';
import 'package:manager/controllers/AuthController.dart';
import 'package:manager/controllers/RoomController.dart';
import 'package:manager/models/RoomItemModel.dart';
import 'package:manager/models/RoomModel.dart';

class RoomRepository {
  final Ref ref;

  RoomRepository({
    required this.ref,
  });

  Future<RoomModel?> getDetailRoom(String id) async {
    try {
      var url = Uri.https(BASE_URL, '/api/collections/rooms/records/$id', {
        'expand': 'items.menu'
      });
      var response = await http.get(url, headers: {
        'authorization': ref.watch(authControllerProvider).token ?? "",
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        RoomModel room = RoomModel.fromMap(data);
        return room;
      } 
      else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  Future<bool> booking(String id, List<RoomItemModel> items) async {
    try {
      var url = Uri.https(BASE_URL, '/api/collections/rooms/records/$id');
      var response = await http.patch(url, headers: {
        'authorization': ref.watch(authControllerProvider).token ?? "",
        "Content-Type": "application/json"
      }, body: json.encode({
        'status': RoomStatus.booking.toJson()
      }));

      await deleteAllItemInRoom(items.map((x) => x.id).toList());

      if (response.statusCode == 200) {
        return true;
      } 
      else {
        return false;
      }
    } catch(e) {
      return false;
    }
  }

  Future<RoomModel?> updateItemInRoom(String roomId, List<RoomItemModel> delItems, List<RoomItemModel> createItems) async {
    try {
      await deleteAllItemInRoom(delItems.map((x) => x.id).toList());

      final items = await createManyRoomItem(createItems);

      var url = Uri.https(BASE_URL, '/api/collections/rooms/records/$roomId', {
        'expand': 'items.menu'
      });

      var response = await http.patch(url, headers: {
        'authorization': ref.watch(authControllerProvider).token ?? "",
        "Content-Type": "application/json"
      }, body: json.encode({
        'items': items.map((x) => x.id).toList()
      }));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        RoomModel room = RoomModel.fromMap(data);
        return room;
      } 
      else {
        return null;
      }
    } catch(e) {
      print(e);
      return null;
    }
  }



  Future<bool> cancelOrder(String id) async {
    try {
      var url = Uri.https(BASE_URL, '/api/collections/rooms/records/$id');
      var response = await http.patch(url, headers: {
        'authorization': ref.watch(authControllerProvider).token ?? "",
        "Content-Type": "application/json"
      }, body: json.encode({
        'status': RoomStatus.booking.toJson()
      }));

      if (response.statusCode == 200) {
        return true;
      } 
      else {
        return false;
      }
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteAllItemInRoom(List<String> items) async {
    try {
      var responses = await Future.wait(
        items.map((id) => ((() async {
          var url = Uri.https(BASE_URL, '/api/collections/room_items/records/$id');
          return await http.delete(url, headers: {
            'authorization': ref.watch(authControllerProvider).token ?? "",
            "Content-Type": "application/json"
          }, body: json.encode({
            'status': RoomStatus.booking.toJson()
          }));
      })())).toList());
    } catch(e) {}
  }

  Future<List<RoomItemModel>> createManyRoomItem(List<RoomItemModel> items) async {
    try {
      var url = Uri.https(BASE_URL, '/api/collections/room_items/records', {
        'expand': 'menu'
      });
      var responses = await Future.wait(
        items.map((item) => ((() async {
          return await http.post(url, headers: {
            'authorization': ref.watch(authControllerProvider).token ?? "",
            "Content-Type": "application/json"
          }, body: json.encode({
            'menu': item.menu.id,
            'quantity': item.quantity
          }));
      })())).toList());

      List<RoomItemModel> list = [];
      for (var response in responses) {
        if (response.statusCode == 200) {
          list.add(RoomItemModel.fromJson(response.body));
        }
      }

      return list;
    } catch(e) { return [];}
  }
}

final roomRepositoryProvider = Provider((ref) {
  return RoomRepository(ref: ref);
});