import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:flup/src/constants/urls_paths.dart';
import 'package:flup/src/library/principal_provider.dart';
import 'package:flup/src/models/producto_model.dart';

class ProductosProvider extends PrincipalProvider<ProductoModel> {
  final String url = 'https://flup-test.firebaseio.com';
  final String segmento = 'productos';

  Future<String> subirImagen(File imagen) async {
    final uri = Uri.parse(IMAGE_SERVER_URL);
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      uri,
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(
        mimeType[0],
        mimeType[1],
      ),
    );

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print(response.body);
      return null;
    }
    final responseData = json.decode(response.body);
    return responseData['secure_url'];
  }
}
