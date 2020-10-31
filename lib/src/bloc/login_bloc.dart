import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'validators.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar los datos del stream
  get emailStream => _emailController.stream.transform(validarEmail);
  get passwordStream => _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (email, password) => true);

  // Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // obtener el ultimo valor ingresado
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
