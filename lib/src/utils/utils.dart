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
  Function onPressed: null,
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
