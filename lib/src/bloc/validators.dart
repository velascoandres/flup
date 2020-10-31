import 'dart:async';

class Validators {
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (String password, sink) {
      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError('Ingrese más de 6 caratéres');
      }
    },
  );

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (String email, sink) {
      Pattern patron =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(patron);

      if (regExp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError('Email no es correcto');
      }
    },
  );
}
