// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:manager/config/app.dart';
import 'package:manager/controllers/AuthController.dart';
import 'package:manager/models/MenuCategory.dart';

class MenuCategoryRepository {
  final Ref ref;

  MenuCategoryRepository({
    required this.ref,
  });

  Future<List<MenuCategoryModel>> getList() async {
    try {
      var url = Uri.https(BASE_URL, '/api/collections/menu_categories/records', {
        "expand": "menus(category)"
      });
      var response = await http.get(url, headers: {
        'authorization': ref.watch(authControllerProvider).token ?? "",
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<MenuCategoryModel> records = List<MenuCategoryModel>.from((data['items'] as List<dynamic>).map<MenuCategoryModel>((x) => MenuCategoryModel.fromMap(x as Map<String,dynamic>),),);
        return records;
      } 
      else {
        throw "";
      }
    } catch(e) {
      return []; 
    }
  }
}

final menuCategoryRepositoryProvider = Provider((ref) {
  return MenuCategoryRepository(ref: ref);
});