import 'dart:convert';
import 'package:flup/src/library/serializable_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

typedef FromJsonCallBack<T> = T Function(Map<String, dynamic> json);

abstract class PrincipalProvider<T extends DeserializableModel> {
  @protected
  final String url = '';

  @protected
  final String segmento = '';

  Future<bool> create(
    T model,
  ) async {
    final uri = '$url/$segmento.json';
    final modelParsed = json.encode(model.toJson());

    // Handling response
    try {
      final response = await http.post(uri, body: modelParsed);
      if (response.statusCode == 200) return true;
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> update(
    String id,
    T model,
  ) async {
    final uri = '$url/$segmento/$id.json';
    final modelParsed = json.encode(model.toJson());

    // Handling response
    try {
      final response = await http.put(uri, body: modelParsed);
      if (response.statusCode == 200) return true;
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<List<T>> findAll(
    FromJsonCallBack fromJsonCallBack,
  ) async {
    final uri = '$url/$segmento.json';
    final response = await http.get(uri);

    final List<T> list = new List();

    // Handling response
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);

        if (decodedData == null) return [];

        decodedData.forEach(
          (id, model) {
            final T parsedModel = fromJsonCallBack(
              {
                ...model,
                'id': id,
              },
            );
            list.add(parsedModel);
          },
        );
        return list;
      }
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<bool> delete(
    String id,
  ) async {
    final uri = '$url/$segmento/$id.json';
    print(uri);
    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) return true;
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
