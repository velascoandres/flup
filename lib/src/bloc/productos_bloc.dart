import 'dart:io';

import 'package:flup/src/models/producto_model.dart';
import 'package:flup/src/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductosProvider();

  Stream<List<ProductoModel>> get productosStream =>
      _productosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;

  void cargarProductos() async {
    final productos =
        await _productosProvider.findAll(ProductoModel.fromJsonToModel);
    _productosController.sink.add(productos);
  }

  Future<bool> agregarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    final creo = await _productosProvider.create(producto);
    _cargandoController.sink.add(false);
    return creo;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    final edito = await _productosProvider.update(producto.id, producto);
    //_productosController.sink.add(producto);
    _cargandoController.sink.add(false);
    return edito;
  }

  Future<bool> borrarProducto(String id) async {
    _cargandoController.sink.add(true);
    final borro = await _productosProvider.delete(id);
    _cargandoController.sink.add(false);
    return borro;
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProvider.subirImagen(foto);
    _cargandoController.sink.add(false);
    return fotoUrl;
  }

  void dispose() {
    _productosController.close();
    _cargandoController.close();
  }
}
