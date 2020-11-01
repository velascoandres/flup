import 'package:flup/src/models/producto_model.dart';
import 'package:flup/src/providers/productos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flup/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  ProductoPage({Key key}) : super(key: key);

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  ProductoModel productoModel = new ProductoModel();

  final productoProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    final ProductoModel productoArg = ModalRoute.of(context).settings.arguments;
    if (productoArg != null) productoModel = productoArg;

    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _guardarBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: productoModel.titulo,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textCapitalization: TextCapitalization.sentences,
      onSaved: (value) => productoModel.titulo = value,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      validator: (value) {
        return value.length < 3 ? 'Ingrese el nombre del producto' : null;
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
        initialValue: productoModel.valor.toString(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onSaved: (value) => productoModel.valor = double.parse(value),
        decoration: InputDecoration(
          labelText: 'Precio',
        ),
        validator: (value) {
          return utils.isNumeric(value) ? null : 'Ingrese un número';
        });
  }

  Widget _guardarBoton() {
    final bool debeEditar = productoModel.id != null;
    final String mensaje = debeEditar ? 'Editar' : 'Guardar';
    final Color color = debeEditar ? Colors.blueAccent : Colors.green;
    final IconData icono = debeEditar ? Icons.update : Icons.save;

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: color,
      label: Text(
        mensaje,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      icon: Icon(icono),
      onPressed: _submit,
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: productoModel.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(
        () => productoModel.disponible = value,
      ),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    final bool debeEditar = productoModel.id != null;
    if (debeEditar) {
      final bool edito = await productoProvider.update(productoModel.id, productoModel);
      if (edito){
          // utils.mostrarSnackbar(
          //   context,
          //   mensaje: 'Producto editado!!',
          //   onPressed: () {},
          // );
      } else {
          // utils.mostrarSnackbar(
          //   context,
          //   mensaje: 'Error al editar!!',
          //   onPressed: () {},
          // );
      }
    } else {
      final bool creo = await productoProvider.create(productoModel);
      if (creo){
          // utils.mostrarSnackbar(
          //   context,
          //   mensaje: 'Producto creado!!',
          //   onPressed: () {},
          // );
      } else {
          // utils.mostrarSnackbar(
          //   context,
          //   mensaje: 'Error al crear!!',
          //   onPressed: () {},
          // );
      }
    }
  }
}
