import 'package:flup/src/bloc/login_bloc.dart';
import 'package:flup/src/bloc/productos_bloc.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final _loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
  }
}
