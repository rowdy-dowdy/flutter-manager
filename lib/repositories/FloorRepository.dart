// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:manager/config/app.dart';
import 'package:manager/controllers/AuthController.dart';
import 'package:manager/models/Floor.dart';
import 'package:manager/models/UserModel.dart';
import 'package:manager/services/shared_prefs_service.dart';

class FloorRepository {
  final Ref ref;

  FloorRepository({
    required this.ref,
  });

  Future<List<FloorModel>> getListFloor() async {
    try {
      var url = Uri.https(BASE_URL, '/api/collections/floors/records', {
        "expand": "rooms(floor)"
      });
      var response = await http.get(url, headers: {
        'authorization': ref.watch(authControllerProvider).token ?? "",
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<FloorModel> floors = List<FloorModel>.from((data['items'] as List<dynamic>).map<FloorModel>((x) => FloorModel.fromMap(x as Map<String,dynamic>),),);
        return floors;
      } 
      else {
        throw Exception('BarException');
      }
    } catch(e) {
      throw Exception('BarException'); 
    }
  }
}

final floorRepositoryProvider = Provider((ref) {
  return FloorRepository(ref: ref);
});