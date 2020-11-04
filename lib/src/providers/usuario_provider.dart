import 'dart:convert';
import 'package:flup/src/shared_prefs/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

enum OPERATION {
  signInWithPassword,
  signUp,
}

class UsuarioProvider {
  final String _fireBaseToken = 'AIzaSyAHztdJPe0rVppSz7qGE0Lw5bv7otMnu4o';
  final prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    return await _accountOperation(email, password, OPERATION.signUp);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _accountOperation(
        email, password, OPERATION.signInWithPassword);
  }

  Future<Map<String, dynamic>> _accountOperation(
      String email, String password, OPERATION operation) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final String operationName = operation.toString().split('.').last;
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$operationName?key=$_fireBaseToken';

    final resp = await http.post(url, body: json.encode(authData));
    Map<String, dynamic> decodeResp = json.decode(resp.body);
    print(resp.body);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      // salvar el token en el storage
      final token = decodeResp['idToken'];
      prefs.token = token;
      return {'ok': true, 'token': token};
    } else {
      return {'ok': false, 'message': decodeResp['error']['message']};
    }
  }
}
