import 'dart:convert';

import 'package:flup/src/library/serializable_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

abstract class PrincipalProvider<T extends DeserializableModel> {
  @protected
  final String url = '';

  @protected
  final String segmento = '';

  Future<bool> create(
    T model,
  ) async {
    final uri = '$url/$segmento';
    final modelParsed = json.encode(model.toJson());
    final response = await http.post(uri, body: modelParsed);

    // Handling response
    try {
      if (response.statusCode == 200) return true;
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
