// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:manager/config/app.dart';
import 'package:manager/models/Floor.dart';
import 'package:manager/models/UserModel.dart';
import 'package:manager/services/shared_prefs_service.dart';
class FloorRepository {
  final Ref ref;

  FloorRepository({
    required this.ref,
  });

  Future<FloorModel?> getListFloor(String id) async {
    var url = Uri.https(BASE_URL, '/api/collections/floors/records?expand=rooms(floor)');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      FloorModel floor = FloorModel.fromMap(data['items']);
      return data;
    } 
    else {
      return null;
    }
  }
}

final floorRepositoryProvider = Provider((ref) {
  return FloorRepository(ref: ref);
});