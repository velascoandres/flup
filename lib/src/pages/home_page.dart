import 'package:flup/src/bloc/productos_bloc.dart';
import 'package:flup/src/constants/images_paths.dart';
import 'package:flutter/material.dart';

import 'package:flup/src/bloc/provider.dart';
import 'package:flup/src/models/producto_model.dart';
import 'package:flup/src/providers/productos_provider.dart';
import 'package:flup/src/utils/utils.dart' as utils;

class HomePage extends StatelessWidget {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    print('Aqui');
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      floatingActionButton: _crearBoton(context),
      body: _crearListaProductos(productosBloc),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }

  Widget _crearListaProductos(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) =>
                _productoItem(context, productos[index], productosBloc),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _productoItem(
    BuildContext context,
    ProductoModel producto,
    ProductosBloc productosBloc,
  ) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
      ),
      onDismissed: (address) async {
        final borro = await productosBloc.borrarProducto(producto.id);
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
      child: Card(
        child: Column(
          children: [
            _mostarImagenProducto(producto),
            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text('${producto.id}'),
              onTap: () =>
                  Navigator.pushNamed(context, 'producto', arguments: producto),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mostarImagenProducto(ProductoModel productoModel) {
    final tieneFotografia = productoModel.fotoUrl != null;
    if (tieneFotografia) {
      return FadeInImage(
        placeholder: AssetImage(LOADER_IMAGE),
        image: NetworkImage(productoModel.fotoUrl),
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image(image: AssetImage(NO_IMAGE));
    }
  }
}
