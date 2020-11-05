import 'dart:async';

import 'package:flup/src/providers/usuario_provider.dart';
import 'package:flup/src/shared_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'validators.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _tokenController = BehaviorSubject<String>();

  final _usuarioProvider = new UsuarioProvider();
  final _preferenciasUsuario = new PreferenciasUsuario();

  // Recuperar los datos del stream
  get emailStream => _emailController.stream.transform(validarEmail);
  get passwordStream => _passwordController.stream.transform(validarPassword);
  get tokenStream => _tokenController.stream;

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (email, password) => true);

  // Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeToken => _tokenController.sink.add;

  // obtener el ultimo valor ingresado
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get token => _tokenController.value;

  // Refrescar token
  Future<bool> loginRefrescarToken(String email, String password) async {
    final Map<String, dynamic> respuesta =
        await _usuarioProvider.login(email, password);
    if (respuesta['ok']) {
      _preferenciasUsuario.token = respuesta['token'];
      _preferenciasUsuario.email = this.email;
      _preferenciasUsuario.password = this.password;
      changeToken(respuesta['token']);
      return true;
    } else {
      _preferenciasUsuario.token = '';
      changeToken('');
      return false;
    }
  }

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _tokenController?.close();
  }
}
