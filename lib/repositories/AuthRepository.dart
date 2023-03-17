// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:manager/config/app.dart';
import 'package:manager/models/UserModel.dart';
import 'package:manager/services/shared_prefs_service.dart';

class UserData {
  final UserModel user;
  final String token;

  UserData({
    required this.user,
    required this.token,
  });
}

class AuthRepository {
  final Ref ref;

  AuthRepository({
    required this.ref,
  });

  Future<UserModel?> userDataById(String id) async {
    var url = Uri.https(BASE_URL, '/api/collections/users/records/:$id');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      UserModel user = UserModel.fromJson(response.body);
      return user;
    } 
    else {
      return null;
    }
  }

  Future<UserData?> getCurrentUserData() async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    String? token = await prefs.getString('token');

    if (token == null) return null;

    var url = Uri.https(BASE_URL, '/api/collections/users/auth-refresh');
    var response = await http.post(url, headers: {
      'authorization': token,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UserModel user = UserModel.fromMap(data['record']);
      String token = data['token'];

      return UserData(user: user, token: token);
    } 
    else {
      return null;
    }
  }

  Future<UserData?> signInWithPassword(String identity, String password) async {
    var url = Uri.https(BASE_URL, '/api/collections/users/auth-with-password');
    var response = await http.post(url, body: {
      "identity": identity,
      "password": password
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UserModel user = UserModel.fromMap(data['record']);
      String token = data['token'];

      final prefs = await ref.read(sharedPrefsProvider.future);
      await prefs.setString('token', data['token']);

      return UserData(user: user, token: token);
    } 
    else {
      return null;
    }
  }
}

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(ref: ref);
});