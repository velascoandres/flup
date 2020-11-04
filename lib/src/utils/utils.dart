import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;
  final numero = num.tryParse(s);
  return numero == null ? false : true;
}

void mostrarSnackbar(
  BuildContext context, {
  String mensaje: '',
  String label: '',
  Function onPressed,
}) {
  final snackBar = SnackBar(
    content: Text(mensaje),
    action: SnackBarAction(
      label: label,
      onPressed: onPressed,
    ),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(mensaje),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
