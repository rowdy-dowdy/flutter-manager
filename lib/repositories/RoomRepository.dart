// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:manager/config/app.dart';
import 'package:manager/controllers/AuthController.dart';
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
}

final roomRepositoryProvider = Provider((ref) {
  return RoomRepository(ref: ref);
});