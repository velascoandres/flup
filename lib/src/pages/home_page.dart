import 'package:flutter/material.dart';

import 'package:flup/src/bloc/provider.dart';
import 'package:flup/src/models/producto_model.dart';
import 'package:flup/src/providers/productos_provider.dart';
import 'package:flup/src/utils/utils.dart' as utils;

class HomePage extends StatelessWidget {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      floatingActionButton: _crearBoton(context),
      body: _crearListaProductos(),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }

  Widget _crearListaProductos() {
    return FutureBuilder(
      future: productosProvider.findAll(
        ProductoModel.fromJsonToModel,
      ),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) =>
                _productoItem(context, productos[index]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _productoItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
      ),
      onDismissed: (address) async {
        final bool borro = await productosProvider.delete(producto.id);
        if (borro) {
          utils.mostrarSnackbar(
            context,
            mensaje: 'Producto Borrado!!',
            onPressed: () {},
          );
        } else {
          utils.mostrarSnackbar(
            context,
            mensaje: 'Error al borrar!!',
            onPressed: () {},
          );
        }
      },
      child: ListTile(
        title: Text('${producto.titulo} - ${producto.valor}'),
        subtitle: Text('${producto.id}'),
        onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
      ),
    );
  }
}
